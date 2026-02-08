# Bootstrap Admin Template

## Overview
This directory contains the **Sneat Bootstrap 5 HTML Admin Template** used as the frontend foundation for the Smart WMS project. The template provides pre-built UI components, layouts, and styling that are integrated into the JSP views.

## Purpose
- **Source of Truth**: Reference HTML pages showing correct structure and styling
- **Asset Repository**: CSS, JavaScript, fonts, and vendor libraries used in `webapp/`
- **Component Library**: Ready-to-use UI components (forms, tables, modals, alerts, etc.)
- **Layout System**: Header, sidebar, navbar, and footer structures

## Directory Structure

```
template/
├── index.html              # Main dashboard template
├── html/                   # Reference HTML pages
│   ├── auth-login-basic.html          # Login page template
│   ├── auth-register-basic.html       # Registration page template
│   ├── forms-basic-inputs.html        # Form components
│   ├── tables-basic.html              # Table layouts
│   ├── ui-modals.html                 # Modal dialogs
│   └── ...                            # Other UI components
├── assets/                 # Template assets (copied to webapp/assets/)
│   ├── css/
│   │   └── demo.css                   # Demo customizations
│   ├── js/
│   │   ├── config.js                  # Template configuration
│   │   ├── main.js                    # Core template JS
│   │   └── ...                        # Page-specific scripts
│   ├── img/                           # Images, icons, avatars
│   └── vendor/                        # Third-party libraries
│       ├── css/
│       │   └── core.css               # Core Bootstrap styles
│       ├── js/
│       │   ├── bootstrap.js           # Bootstrap JavaScript
│       │   ├── helpers.js             # Utility functions
│       │   └── menu.js                # Sidebar menu logic
│       └── libs/                      # External libraries
│           ├── jquery/
│           ├── apex-charts/           # Chart library
│           ├── perfect-scrollbar/     # Custom scrollbars
│           └── ...
├── js/                     # Core JavaScript files
│   ├── bootstrap.js
│   ├── helpers.js
│   └── menu.js
└── libs/                   # Source libraries (SCSS, unminified JS)
```

## Key Components

### Authentication Pages
- [html/auth-login-basic.html](html/auth-login-basic.html) - Login form layout
- [html/auth-register-basic.html](html/auth-register-basic.html) - Registration form
- [html/auth-forgot-password-basic.html](html/auth-forgot-password-basic.html) - Password recovery

### Forms
- [html/forms-basic-inputs.html](html/forms-basic-inputs.html) - Input fields, textareas, selects
- [html/form-layouts-vertical.html](html/form-layouts-vertical.html) - Vertical form layout
- [html/form-layouts-horizontal.html](html/form-layouts-horizontal.html) - Horizontal form layout

### Tables
- [html/tables-basic.html](html/tables-basic.html) - Table structures with sorting, pagination

### UI Components
- [html/ui-modals.html](html/ui-modals.html) - Modal dialogs
- [html/ui-alerts.html](html/ui-alerts.html) - Alert messages
- [html/ui-toasts.html](html/ui-toasts.html) - Toast notifications
- [html/ui-buttons.html](html/ui-buttons.html) - Button styles
- [html/ui-cards.html](html/cards-basic.html) - Card layouts

## Integration with Smart WMS

### Asset Copying
Template assets are copied to `webapp/` during development:
```
template/assets/ → webapp/assets/
template/js/ → webapp/js/
template/libs/ → webapp/libs/
```

### JSP Layout Components
JSP views include template-based layouts:
- `views/layout/header.jsp` - Based on template header structure
- `views/layout/sidebar.jsp` - Navigation menu from template
- `views/layout/navbar.jsp` - Top navigation bar
- `views/layout/footer.jsp` - Footer section

### Usage Pattern
1. **Find component** in `template/html/*.html`
2. **Copy HTML structure** to JSP view
3. **Replace static content** with JSTL tags (`<c:forEach>`, `${product.name}`, etc.)
4. **Keep classes and IDs** from template for consistent styling

## Styling System

### CSS Files (loaded in order)
1. `assets/vendor/css/core.css` - Bootstrap 5 base + theme customizations
2. `assets/vendor/css/theme-default.css` - Color scheme variables
3. `assets/vendor/libs/*.css` - Plugin-specific styles (ApexCharts, PerfectScrollbar)
4. `assets/css/demo.css` - Demo-specific styles (optional)

### JavaScript Files (loaded in order)
1. `assets/vendor/libs/jquery/jquery.js` - jQuery 3.x
2. `assets/vendor/libs/popper/popper.js` - Bootstrap dependency
3. `assets/vendor/js/bootstrap.js` - Bootstrap 5 JavaScript
4. `assets/vendor/js/helpers.js` - Utility functions
5. `assets/vendor/js/menu.js` - Sidebar menu behavior
6. `assets/js/main.js` - Template initialization

## Key Features

### Responsive Design
- Mobile-first approach
- Collapsible sidebar on mobile
- Responsive tables with horizontal scrolling

### Theme Support
- Light/dark mode toggle (via `config.js`)
- Customizable color scheme
- RTL support ready

### Components
- **Bootstrap 5**: Latest version with utility classes
- **ApexCharts**: Interactive data visualization
- **Perfect Scrollbar**: Customized scrollbars for consistent UI
- **jQuery**: DOM manipulation and AJAX
- **Iconify Icons**: Icon library via CDN

## Configuration

### Template Settings (`assets/js/config.js`)
```javascript
window.templateCustomizer = {
  theme: 'theme-default',           // Theme name
  style: 'light',                   // 'light' or 'dark'
  contentLayout: 'compact',         // 'compact' or 'wide'
  showDropdownOnHover: true         // Mega menu behavior
};
```

## Development Notes

### DO NOT Modify Template Directly
- This folder is a reference copy
- Make changes in `webapp/` instead
- Keep template pristine for comparison

### When Updating Template
1. Backup current `template/` folder
2. Replace with new template version
3. Re-apply any custom modifications
4. Test all JSP views for compatibility
5. Update asset references in `webapp/`

### Common Issues
- **Missing styles**: Check if CSS files are copied to `webapp/assets/vendor/css/`
- **Broken JavaScript**: Ensure correct load order in JSP layout files
- **Icons not showing**: Verify Iconify CDN link in header
- **Sidebar not working**: Check `menu.js` is loaded after `helpers.js`

## Reference Documentation
- Bootstrap 5 Docs: https://getbootstrap.com/docs/5.3/
- ApexCharts: https://apexcharts.com/docs/
- jQuery: https://api.jquery.com/

## Version
**Sneat Bootstrap 5 HTML Admin Template** v1.x (Commercial template)

---

**For Smart WMS Developers**: When creating new JSP views, always reference the corresponding HTML file in this template first to ensure consistent styling and behavior.
