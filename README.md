# 🇷🇴 OSIM 50x50mm Resizer CLI (`cli-osim-resizer`)

> **🌐 NEW: Live Web Version Available!**
> Don't want to use the terminal? Try our free, drag-and-drop **[Web App](https://alexia-consta.github.io/cli-osim-resizer/)**.
> It requires zero installation, features a live interactive color picker, and processes everything securely right inside your browser (no data is uploaded).

---

A powerful, cross-platform command-line tool designed specifically for Romanian Trademark (OSIM) applications. It perfectly resizes logos and images to the mandatory 50x50mm (300 DPI) JPEG format. 

It features intelligent transparency detection and an interactive prompt to generate custom background colors using Hex, RGB, or HSL so your trademark background is exactly what you want.

## 🚀 Installation

Copy and paste the command for your operating system into your terminal:

### 🍎 macOS
1.  **Install Homebrew** (Package manager for Mac):
    If you don't have it, install it here: [brew.sh](https://brew.sh/)
2.  **Install Node.js & NPM**:
    ```
    brew install node
    ```
3.  **Install the Resizer globally**:
    ```
    npm install -g alexia-consta/cli-osim-resizer
    ```

### 🪟 Windows (Run in Command Prompt / CMD)
```
curl -sSL https://raw.githubusercontent.com/alexia-consta/cli-osim-resizer/main/install-windows.cmd > install.cmd && install.cmd && del install.cmd
```

## 📖 Usage
Once installed, you can run the tool from any folder on your computer. Simply type the command followed by the name of your image:
```
osim-resizer testphoto.png
```
## ✨ Interactive Colors

If your image has transparency, the tool will ask for a background color. You can enter:
Plain Names:
```
white, black, azure
```
Hex:
```
FF2344 or #FF2344
```
Modern CSS:
```
oklch(70% 0.122 150) or rgb(255, 255, 255)
```
If you choose not to provide a custom color, the tool will automatically generate high-quality White and Black background versions for you to choose from.

## ⚖️ License
Distributed under the MIT License. See ```LICENSE```for more information.
