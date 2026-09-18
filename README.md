# HackBar

**HackBar** es una barra informativa ligera para **Kali Linux con XFCE**. Se integra en el panel superior estándar de Kali: no sustituye el menú, no instala BSPWM y no usa Polybar.

**by:** dvdmor

Muestra:

- IP local
- estado, nombre e IP de la VPN
- IP objetivo (`target`)
- uso de CPU
- memoria RAM usada/total
- fecha y hora local
- hora UTC

## Instalación

Ejecuta la instalación como tu usuario normal de Kali, **no como root**:

```bash
git clone https://github.com/4iseg/hackbar.git
cd hackbar
chmod +x install.sh
./install.sh
```

El instalador añade automáticamente un **Generic Monitor** al panel XFCE y mantiene el resto de la configuración estándar de Kali.

## Cambiar el target

Configurar la IP de la máquina que vas a auditar:

```bash
target 10.0.2.22
```

Ver el target actual:

```bash
target
```

Eliminarlo:

```bash
target clear
```

El panel se actualiza automáticamente al cambiar el target.

## Ejemplo

```text
🌐 10.0.2.15   🔓 VPN OFF   🎯 10.0.2.22   ⚙ 4%   🧠 1.0G/15G   📅 18/09/26 09:15   UTC 07:15
```

Con una VPN activa:

```text
🌐 192.168.1.40   🔒 HTB 10.10.14.23   🎯 10.10.11.52   ⚙ 7%   🧠 2.8G/15G   📅 18/09/26 09:15   UTC 07:15
```

## Desinstalación

```bash
./uninstall.sh
```

El desinstalador elimina únicamente HackBar y sus scripts. No desinstala `xfce4-genmon-plugin`, porque podría estar siendo utilizado por otros elementos del panel.

## Requisitos

- Kali Linux
- XFCE
- `sudo`
- conexión a Internet si es necesario instalar `xfce4-genmon-plugin`

## Licencia

MIT.
