import json
import argparse
import time
from macapptree import get_app_bundle, get_tree
from custom_extractors import extract_system_wide_accessibility_tree
try:
    from AppKit import NSWorkspace
except ImportError:
    NSWorkspace = None

def get_focused_app_info():
    """Get information about the currently focused application"""
    if NSWorkspace is None:
        return None
    
    try:
        workspace = NSWorkspace.sharedWorkspace()
        active_app = workspace.activeApplication()
        if active_app:
            return {
                "bundle_id": active_app.get("NSApplicationBundleIdentifier"),
                "name": active_app.get("NSApplicationName"),
                "path": active_app.get("NSApplicationPath"),
                "pid": active_app.get("NSApplicationProcessIdentifier")
            }
    except Exception as e:
        print(f"Error getting focused app info: {e}")
    
    return None

def get_tree_with_display_info(bundle, max_depth=None):
    """Wrapper around get_tree for consistency with the rest of the codebase"""
    return get_tree(bundle, max_depth)

from Quartz import (
    CGWindowListCopyWindowInfo,
    kCGWindowListOptionOnScreenOnly,
    kCGNullWindowID,
    kCGWindowOwnerName,
    kCGWindowBounds
)

def get_accessibility_tree_passive(max_depth=None, display_filter=None):
    """
    Get accessibility tree using passive extraction without focus stealing.
    Supports filtering by specific display for recording purposes.
    
    Args:
        max_depth: Maximum depth for tree traversal
        display_filter: Only capture applications on this display (None = all displays)
    """
    try:
        all_windows = extract_system_wide_accessibility_tree(max_depth)
        
        # Group windows by application
        apps_data = {}
        for window_data in all_windows:
            # Filter by display if specified
            if display_filter is not None and window_data['display_index'] != display_filter:
                continue
                
            app_name = window_data['app_name']
            if app_name not in apps_data:
                apps_data[app_name] = {
                    'name': app_name,
                    'role': 'application',
                    'description': '',
                    'value': '',
                    'bbox': {'x': 0, 'y': 0, 'width': 0, 'height': 0},
                    'children': [],
                    'displays': set()  # Track which displays this app spans
                }
            
            # Add window data to app
            window_node = {
                'role': 'window',
                'name': f"Window on display {window_data['display_index']}",
                'description': f"Display {window_data['display_index']}",
                'value': '',
                'bbox': {
                    'x': window_data['position']['x'],
                    'y': window_data['position']['y'],
                    'width': window_data['size']['width'],
                    'height': window_data['size']['height']
                },
                'display_index': window_data['display_index'],
                'children': convert_passive_tree_to_legacy_format(window_data['accessibility_tree'])
            }
            
            apps_data[app_name]['children'].append(window_node)
            apps_data[app_name]['displays'].add(window_data['display_index'])
        
        # Convert to list and add display info to app descriptions
        result = []
        for app_name, app_data in apps_data.items():
            # Skip apps with no windows (after filtering)
            if not app_data['children']:
                continue
                
            displays_list = sorted(list(app_data['displays']))
            if display_filter is not None:
                app_data['description'] = f"Display {display_filter}"
            else:
                app_data['description'] = f"Spans displays: {displays_list}"
            del app_data['displays']  # Remove the set before serialization
            result.append(app_data)
        
        return result
        
    except Exception as e:
        print(f"Error in passive accessibility extraction: {e}")
        # Fallback to legacy method if passive fails
        return get_accessibility_tree_legacy(display_filter)

def convert_passive_tree_to_legacy_format(passive_tree):
    """Convert passive tree format to legacy format for compatibility"""
    if not passive_tree or 'attributes' not in passive_tree:
        return []
    
    attrs = passive_tree['attributes']
    children = passive_tree.get('children', [])
    
    # Convert to legacy format
    legacy_node = {
        'role': attrs.get('role', ''),
        'name': attrs.get('title', ''),
        'description': attrs.get('description', ''),
        'value': attrs.get('value', ''),
        'bbox': attrs.get('bbox', {'x': 0, 'y': 0, 'width': 0, 'height': 0}),
        'children': [convert_passive_tree_to_legacy_format(child) for child in children]
    }
    
    return [legacy_node] if legacy_node['role'] else []

def get_accessibility_tree_legacy(display_filter=None):
    """Legacy method using CGWindowList (fallback) - NO hit-testing
    
    Args:
        display_filter: Only capture applications on this display (None = all displays)
    """
    print(f"[Legacy] Starting CGWindowList extraction at {time.time()}")
    # Reduced filter list - only system components that should never be recorded
    INVALID_WINDOWS=['Window Server', 'Dock', 'Spotlight', 'SystemUIServer', 'ControlCenter', 'NotificationCenter', 'clones', 'clones_desktop']
    
    options = kCGWindowListOptionOnScreenOnly
    print(f"[Legacy] Getting window list at {time.time()}")
    windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID)
    print(f"[Legacy] Got {len(windowList) if windowList else 0} windows at {time.time()}")
    
    app_windows = {}
    
    for window in windowList:
        app_name = None
        bounds = None
        
        for key, value in window.items():
            if key == kCGWindowOwnerName:
                app_name = value
            elif key == kCGWindowBounds:
                bounds = value
        
        if app_name and bounds and app_name not in INVALID_WINDOWS:
            # Filter out tiny windows (likely system UI elements)
            if bounds["Width"] > 100 and bounds["Height"] > 100:
                # Determine display
                display_index = 0 if bounds['Y'] >= 0 else 1
                
                # Filter by display if specified
                if display_filter is not None and display_index != display_filter:
                    continue
                
                if app_name not in app_windows:
                    app_windows[app_name] = []
                
                app_windows[app_name].append({
                    'name': f"Window on display {display_index}",
                    'role': 'window',
                    'description': f"Display {display_index}",
                    'value': '',
                    'bbox': {
                        'x': int(bounds['X']),
                        'y': int(bounds['Y']),
                        'width': int(bounds['Width']),
                        'height': int(bounds['Height'])
                    },
                    'display_index': display_index,
                    'children': []  # No hit-testing = no detailed children
                })
    
    # Convert to legacy format
    out = []
    for app_name, windows in app_windows.items():
        # Skip apps with no windows (after filtering)
        if not windows:
            continue
            
        unique_displays = set(w['display_index'] for w in windows)
        if display_filter is not None:
            description = f"Display {display_filter}"
        else:
            description = f"Spans {len(unique_displays)} display(s)"
            
        out.append({
            'name': app_name,
            'role': 'application',
            'description': description,
            'value': '',
            'bbox': {'x': 0, 'y': 0, 'width': 0, 'height': 0},
            'children': windows
        })
    
    print(f"[Legacy] Completed CGWindowList extraction at {time.time()}")
    return out

def get_accessibility_tree(display_filter=None):
 """Main accessibility tree function - uses passive extraction by default"""
    return get_accessibility_tree_passive(display_filter=display_filter)

def main():
    parser = argparse.ArgumentParser(description='Extract accessibility tree from macOS applications')
    parser.add_argument('-o', '--out', help='Output file path (defaults to stdout)')
    parser.add_argument('-e', '--event', help='Output in event format with timing data', action='store_true')
    parser.add_argument('--recording-display', type=int, help='Display index being used for recording (0=primary)', default=None)
    parser.add_argument('--display-index', type=int, help='Only capture applications on specified display (0=primary)', default=None)
    parser.add_argument('--no-focus-steal', action='store_true', help='Use no-focus-steal mode to avoid disrupting user during recording')
    parser.add_argument('--low-frequency', action='store_true', help='Reduce polling frequency to 60s intervals for recording mode')
    args = parser.parse_args()
    
    # Add delay for low-frequency mode
    if args.low_frequency:
        print("Low-frequency mode: This capture is for recording context (60s intervals recommended)")
        # This is just a single capture, but signals the calling system to use 60s intervals

    start_time = int(time.time() * 1000)  # JS equivalent of timestamp_millis
    
    # Determine display filter (use recording-display if specified, otherwise display-index)
    display_filter = args.display_index if args.display_index is not None else args.recording_display
    
    # Choose extraction method based on arguments
    if args.no_focus_steal:
        print("Using no-focus-steal passive extraction mode")
        print(f"Starting passive extraction at {time.time()}")
        try:
            tree = get_accessibility_tree_passive(max_depth=10, display_filter=display_filter)
            print(f"Passive extraction completed at {time.time()}")
        except Exception as e:
            print(f"Passive extraction failed at {time.time()}: {e}")
            print(f"Starting legacy fallback at {time.time()}")
            tree = get_accessibility_tree_legacy(display_filter=display_filter)
            print(f"Legacy fallback completed at {time.time()}")
            print(f"Legacy returned {len(tree)} applications")
    else:
        tree = get_accessibility_tree_legacy(display_filter=display_filter)
    
    end_time = int(time.time() * 1000)
    duration = end_time - start_time
    
    # Get focused app info
    focused_app = get_focused_app_info()

    if args.event:
        output = {
            "time": start_time,
            "data": {
                "duration": duration,
                "tree": tree,
                "focused_app": focused_app
            }
        }
    else:
        output = tree

    json_output = json.dumps(output)

    if args.out:
        with open(args.out, 'w') as f:
            f.write(json_output)
    else:
        print(json_output)
    
    # Force immediate exit to prevent hanging
    import sys
    sys.exit(0)

if __name__ == "__main__":
    main()
