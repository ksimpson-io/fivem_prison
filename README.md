# frudy-prison 🧱

A modular and streamlined prison system for FiveM — built in Lua with clear logic, server sync, and full extensibility.

This system allows players to be jailed, tracked, and released with support for timed sentences, custom logic, and smooth RP integration. Designed to be lightweight and expandable with minimal setup.

> ⚠️ Originally developed for MC9 Gaming. This system was designed and built by me and has been adapted for independent use. No proprietary MC9 assets or systems are included.

---

## 🚀 Features

- ⏱️ **Timed Jail System** — Sentence players for a set duration, auto-release when time is up
- 🧍 **Custom Spawn Handling** — Jail spawn and teleport built-in
- 🔁 **Server-Synced** — Time tracking works even across crashes or relogs
- 📝 **Command + Event Support** — Jail/unJail players manually or programmatically
- 🧠 **Smart Logic** — Prevents stacking, ghost jails, or lost states
- 🔓 **Admin Tools** — Easily expand with RP menus or context UIs
- 🧩 **Modular Design** — Add jobs, reduce time, or implement prison tasks with ease

---

## 🧱 Tech Stack

- **Lua** — Structured, organized scripting with clear separation
- **QBCore** — Framework used for player and job data
- **ox_lib** — Notifications and potential menu integration
- **mc9-core** — Used internally for callback helpers (private)

---

## 🧩 Dependencies

| Resource   | Purpose                                 |
|------------|-----------------------------------------|
| `ox_lib`   | Notifications or context menus          |
| `mc9-core` | Server-side utility & callbacks (private) |
| `oxmysql`  | Optional: Jail record persistence       |

---

## 📦 Installation

1. Download or clone this repository into your `resources` folder.
2. Rename the folder to `frudy-prison` (optional, but clean).
3. Add `ensure frudy-prison` to your `server.cfg`.
4. Make sure the following dependencies are started before it:
   - `ox_lib`
   - `mc9-core` (or replace with your own logic)

---

## ⚙️ Configuration

Edit the core logic directly or extend it with your own handlers.

- Sentence durations are passed via event or command
- Jail spawn coords can be adjusted in `client.lua`
- Export or wrap logic inside your arrest/MDT flow

---

## 🔧 Usage

**Commands:**

```bash
/jail [id] [minutes] [reason] — Jail a player
/unJail [id] — Release a player
```
Events:

`TriggerEvent('prison:server:JailPlayer', id, time, reason)`
Helpers:

`exports['frudy-prison']:IsInJail() -- Returns true/false on client`

📸 Preview
(Add a screenshot or clip of jail spawn, time tracking UI, or command usage)

🔐 License
This script is for demo/showcase purposes only.
Do not resell or repackage without explicit permission.

📄 Credits & Disclaimer
This system was originally created while working with MC9 Gaming. All logic and structure in this version were written by me (frudy) and adapted for independent use.

No proprietary assets or private systems from mc9-core are distributed here. Replace or rebuild any private logic to fit your framework.
