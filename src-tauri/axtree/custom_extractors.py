"""
Custom accessibility extractors that extend macapptree functionality
without duplicating the entire package.
"""

import AppKit
import ApplicationServices
from Quartz import CGDisplayBounds, CGGetOnlineDisplayList


def get_display_info():
    """Get information about all available displays."""
    displays = []
    max_displays = 32
    display_count, active_displays = CGGetOnlineDisplayList(max_displays, None, None)
    
    for i in range(display_count):
        display_id = active_displays[i]
        bounds = CGDisplayBounds(display_id)
        displays.append({
            'frame': {
                'x': bounds.origin.x,
                'y': bounds.origin.y, 
                'width': bounds.size.width,
                'height': bounds.size.height
            }
        })
    
    return displays


def extract_system_wide_accessibility_tree(max_depth=None):
    """
    Extract accessibility tree from the entire system without focus stealing.
    Returns accessibility data for all windows across all displays.
    """
    system_element = ApplicationServices.AXUIElementCreateSystemWide()
    
    # Get all applications
    err, apps = ApplicationServices.AXUIElementCopyAttributeValue(
        system_element, ApplicationServices.kAXChildrenAttribute, None
    )
    
    if err != ApplicationServices.kAXErrorSuccess:
        error_msg = f"Failed to get applications from system element. Error: {err}"
        print(error_msg)
        # Always raise exception for any accessibility error to trigger immediate fallback
        raise RuntimeError(error_msg)
    
    if not apps:
        error_msg = f"No applications found from system element"
        print(error_msg)
        raise RuntimeError(error_msg)
    
    all_windows_data = []
    displays = get_display_info()
    
    print(f"Found {len(apps)} applications to examine")
    print(f"Available displays: {len(displays)}")
    
    for app in apps:
        app_name = None  # Initialize app_name at start of loop
        try:
            # Get app name
            err, app_name = ApplicationServices.AXUIElementCopyAttributeValue(
                app, ApplicationServices.kAXTitleAttribute, None
            )
            if err != ApplicationServices.kAXErrorSuccess or not app_name:
                continue
                
            # Skip system apps that should not be recorded
            INVALID_APPS = ['Window Server', 'Dock', 'Spotlight', 'SystemUIServer', 
                           'ControlCenter', 'NotificationCenter', 'Finder', 'clones']
            if app_name in INVALID_APPS:
                continue
            
            # Get windows for this app
            err, windows = ApplicationServices.AXUIElementCopyAttributeValue(
                app, ApplicationServices.kAXWindowsAttribute, None
            )
            
            if err != ApplicationServices.kAXErrorSuccess or not windows:
                continue
                
            for window in windows:
                try:
                    # Get window position and size
                    err, position_value = ApplicationServices.AXUIElementCopyAttributeValue(
                        window, ApplicationServices.kAXPositionAttribute, None
                    )
                    err2, size_value = ApplicationServices.AXUIElementCopyAttributeValue(
                        window, ApplicationServices.kAXSizeAttribute, None
                    )
                    
                    if (err != ApplicationServices.kAXErrorSuccess or 
                        err2 != ApplicationServices.kAXErrorSuccess):
                        continue
                        
                    # Convert to readable format 
                    # Handle both direct values and string representations
                    if hasattr(position_value, 'x') and hasattr(position_value, 'y'):
                        position = position_value
                    else:
                        position = AppKit.NSPointFromString(str(position_value))
                        
                    if hasattr(size_value, 'width') and hasattr(size_value, 'height'):
                        size = size_value
                    else:
                        size = AppKit.NSSizeFromString(str(size_value))
                    
                    # Filter out tiny windows
                    if size.width < 100 or size.height < 100:
                        continue
                    
                    # Determine which display this window is on
                    window_display_index = 0  # Default to primary
                    window_center_x = position.x + (size.width / 2)
                    window_center_y = position.y + (size.height / 2)
                    
                    for i, display in enumerate(displays):
                        frame = display['frame']
                        if (frame['x'] <= window_center_x <= frame['x'] + frame['width'] and
                            frame['y'] <= window_center_y <= frame['y'] + frame['height']):
                            window_display_index = i
                            break
                    
                    window_data = {
                        'app_name': app_name,
                        'display_index': window_display_index,
                        'position': {'x': int(position.x), 'y': int(position.y)},
                        'size': {'width': int(size.width), 'height': int(size.height)},
                        'accessibility_tree': extract_element_tree_passive(window, max_depth)
                    }
                    
                    all_windows_data.append(window_data)
                    
                except Exception as e:
                    print(f"Error processing window: {e}")
                    continue
                    
        except Exception as e:
            print(f"Error processing app {app_name or 'unknown'}: {e}")
            continue
    
    return all_windows_data


def extract_element_tree_passive(element, max_depth=None, current_depth=0):
    """
    Recursively extract accessibility tree from an element without focus changes.
    This is the core passive extraction that doesn't steal focus.
    """
    if max_depth is not None and current_depth >= max_depth:
        return None
        
    try:
        # Get basic attributes without focus changes
        attributes = {}
        
        # Get role
        err, role = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXRoleAttribute, None
        )
        if err == ApplicationServices.kAXErrorSuccess and role:
            attributes['role'] = str(role)
        
        # Get title/name
        err, title = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXTitleAttribute, None
        )
        if err == ApplicationServices.kAXErrorSuccess and title:
            attributes['title'] = str(title)
            
        # Get value
        err, value = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXValueAttribute, None
        )
        if err == ApplicationServices.kAXErrorSuccess and value:
            attributes['value'] = str(value)
            
        # Get description
        err, description = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXDescriptionAttribute, None
        )
        if err == ApplicationServices.kAXErrorSuccess and description:
            attributes['description'] = str(description)
            
        # Get position and size if available
        err, position = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXPositionAttribute, None
        )
        err2, size = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXSizeAttribute, None
        )
        
        if (err == ApplicationServices.kAXErrorSuccess and position and
            err2 == ApplicationServices.kAXErrorSuccess and size):
            # Handle both direct values and string representations
            if hasattr(position, 'x') and hasattr(position, 'y'):
                pos = position
            else:
                pos = AppKit.NSPointFromString(str(position))
                
            if hasattr(size, 'width') and hasattr(size, 'height'):
                sz = size
            else:
                sz = AppKit.NSSizeFromString(str(size))
                
            attributes['bbox'] = {
                'x': int(pos.x), 'y': int(pos.y),
                'width': int(sz.width), 'height': int(sz.height)
            }
        
        # Get children
        children_data = []
        err, children = ApplicationServices.AXUIElementCopyAttributeValue(
            element, ApplicationServices.kAXChildrenAttribute, None
        )
        
        if err == ApplicationServices.kAXErrorSuccess and children:
            for child in children:
                child_data = extract_element_tree_passive(child, max_depth, current_depth + 1)
                if child_data:
                    children_data.append(child_data)
        
        return {
            'attributes': attributes,
            'children': children_data
        }
        
    except Exception as e:
        print(f"Error extracting element: {e}")
        return None