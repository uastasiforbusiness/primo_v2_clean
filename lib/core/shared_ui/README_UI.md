# 📖 LA BIBLIA DE LA UI (.shared ui)

Este es el lugar sagrado donde reside el ADN visual de **PRIMO V2**. Aquí guardamos los componentes que dan vida, estructura y consistencia a nuestro software.

> "Un solo fondo, una sola alma, un solo sistema."

## 🧱 LOS PILARES

### 1. `app_background.dart` (El Alma)

Es la marca de agua global. Gestiona el logo en tamaño XL con el efecto de cristal que define nuestra identidad.

- **Uso**: Se coloca en la raíz de los layouts principales.

### 2. `app_header.dart` (El Vigía) - ¡NUEVO!

El nuevo header premium que contiene el reloj dinámico y la fecha. Aporta elegancia y utilidad a cada sección.

- **Uso**: Integrado en el MainLayout para control de tiempo y títulos.

### 3. `app_scaffold.dart` (El Templo)

Nuestra versión del Scaffold tradicional. Ya viene preparado para recibir el fondo o mantenerse limpio según se necesite.

- **Uso**: Úsalo en todas las páginas de la aplicación.

### 4. `app_sidebar.dart` (El Navegante)

La columna vertebral de la navegación. Es translúcida para permitir que la identidad visual respire a través de ella.

- **Uso**: Integrada automáticamente en el `MainLayout`.

### 5. `main_layout.dart` (La Estructura)

El molde que une todo: Sidebar + Header + Contenido + Fondo Global. Es lo que hace que la app se sienta sólida y profesional.

---

## 📜 MANDAMIENTOS PARA EL DESARROLLADOR

1. **No crearás fondos locales**: Todo fondo debe venir de `AppBackground`.
2. **Mantendrás la consistencia**: Si un botón es compartido, debe vivir aquí.
3. **Honrarás la jerarquía**: Los componentes aquí son intocables a menos que el cambio sea para evolucionar toda la marca.
4. **Usarás AppScaffold sobre Scaffold**: Para asegurar que nunca perdamos el norte visual.
5. **El tiempo es oro**: El header debe ser el único lugar donde se gestiona el reloj global del sistema.

---

_Este código es de todos y para todos. Guárdalo, cúmplelo y hazlo crecer._
