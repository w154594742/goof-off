use tauri::{
    menu::{MenuBuilder, MenuItemBuilder, PredefinedMenuItem},
    tray::{MouseButton, MouseButtonState, TrayIconBuilder, TrayIconEvent},
    Emitter, Manager,
};
use tauri_plugin_autostart::MacosLauncher;

#[tauri::command]
fn toggle_always_on_top(window: tauri::Window) -> bool {
    let current = window.is_always_on_top().unwrap_or(false);
    let _ = window.set_always_on_top(!current);
    !current
}

fn create_tray(app: &tauri::App) -> tauri::Result<()> {
    let show = MenuItemBuilder::new("显示/隐藏").id("toggle").build(app)?;
    let pin = MenuItemBuilder::new("✅ 窗口置顶").id("pin").build(app)?;
    let sep1 = PredefinedMenuItem::separator(app)?;

    let o100 = MenuItemBuilder::new("不透明 100%").id("opacity_100").build(app)?;
    let o90  = MenuItemBuilder::new("不透明  90%").id("opacity_90").build(app)?;
    let o80  = MenuItemBuilder::new("不透明  80%").id("opacity_80").build(app)?;
    let o70  = MenuItemBuilder::new("不透明  70%").id("opacity_70").build(app)?;
    let o60  = MenuItemBuilder::new("不透明  60%").id("opacity_60").build(app)?;
    let o50  = MenuItemBuilder::new("不透明  50%").id("opacity_50").build(app)?;
    let o40  = MenuItemBuilder::new("不透明  40%").id("opacity_40").build(app)?;
    let o30  = MenuItemBuilder::new("不透明  30%").id("opacity_30").build(app)?;
    let o20  = MenuItemBuilder::new("不透明  20%").id("opacity_20").build(app)?;
    let o10  = MenuItemBuilder::new("不透明  10%").id("opacity_10").build(app)?;

    let sep2 = PredefinedMenuItem::separator(app)?;
    let quit = MenuItemBuilder::new("退出").id("quit").build(app)?;

    let menu = MenuBuilder::new(app)
        .items(&[
            &show, &pin, &sep1,
            &o100, &o90, &o80, &o70, &o60, &o50, &o40, &o30, &o20, &o10,
            &sep2, &quit,
        ])
        .build()?;

    TrayIconBuilder::new()
        .icon(app.default_window_icon().unwrap().clone())
        .tooltip("摸鱼办温馨提示")
        .menu(&menu)
        .show_menu_on_left_click(false)
        .on_menu_event(move |app, event| {
            let window = app.get_webview_window("main").unwrap();
            let id = event.id().as_ref();
            match id {
                "toggle" => {
                    if window.is_visible().unwrap_or(false) {
                        let _ = window.hide();
                    } else {
                        let _ = window.show();
                        let _ = window.set_focus();
                    }
                }
                "pin" => {
                    let current = window.is_always_on_top().unwrap_or(false);
                    let _ = window.set_always_on_top(!current);
                }
                "quit" => {
                    std::process::exit(0);
                }
                _ => {
                    // Handle opacity_XX menu items
                    if let Some(val) = id.strip_prefix("opacity_") {
                        if let Ok(pct) = val.parse::<u32>() {
                            let _ = app.emit("set-opacity", pct as f64 / 100.0);
                        }
                    }
                }
            }
        })
        .on_tray_icon_event(|tray, event| {
            if let TrayIconEvent::Click {
                button: MouseButton::Left,
                button_state: MouseButtonState::Up,
                ..
            } = event
            {
                let app = tray.app_handle();
                if let Some(window) = app.get_webview_window("main") {
                    if window.is_visible().unwrap_or(false) {
                        let _ = window.hide();
                    } else {
                        let _ = window.show();
                        let _ = window.set_focus();
                    }
                }
            }
        })
        .build(app)?;

    Ok(())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_autostart::init(
            MacosLauncher::LaunchAgent,
            Some(vec![]),
        ))
        .plugin(tauri_plugin_store::Builder::default().build())
        .invoke_handler(tauri::generate_handler![toggle_always_on_top])
        .setup(|app| {
            create_tray(app)?;
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
