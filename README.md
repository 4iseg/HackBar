# Kali XFCE Info Bar

Barra informativa ligera para **Kali Linux con XFCE**. Se integra en el panel superior estándar de Kali: no sustituye el menú, no instala BSPWM y no usa Polybar.

Muestra:

- IP local
- estado/nombre/IP de la VPN
- IP objetivo (target)
- uso de CPU
- memoria RAM usada/total
- fecha y hora local
- hora UTC

## Instalación

Ejecuta la instalación como tu usuario normal de Kali, **no como root**:

```bash
git clone https://github.com/4iseg/kali-xfce-bar.git
cd kali-xfce-bar
chmod +x install.sh
./install.sh
```

El instalador añade automáticamente un **Generic Monitor** al panel XFCE y mantiene el resto de la configuración estándar de Kali.

## Target

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

El desinstalador elimina únicamente la barra y sus scripts. No desinstala `xfce4-genmon-plugin`, ya que podría estar siendo utilizado por otros elementos del panel.

## Requisitos

- Kali Linux
- XFCE
- `sudo`
- conexión a Internet si es necesario instalar `xfce4-genmon-plugin`

## Nota

Está pensado para el panel XFCE estándar de Kali. El instalador intenta colocar la barra antes del reloj para no desplazar los controles situados al final del panel.

## Licencia

MIT.
