# 📘 Gestión de Esquemas y Migraciones SQL con DACPAC

Este repositorio permite versionar y sincronizar el esquema de una base de datos SQL Server utilizando archivos `.dacpac`, scripts de migración `.sql` y automatización con scripts `.bat`.

---

## 📁 Estructura del proyecto

```
F:\dacpac\
├── releases\             # Archivos .dacpac versionados por fecha
├── migrations\           # Scripts .sql generados y aplicados
├── tools\                # Scripts .bat para automatizar el flujo
│   ├── backup-dacpac.bat
│   ├── publish-dacpac.bat
│   ├── apply-migrations.bat
│   └── generate-migration-from-dacpac.bat
```

---

## 🧩 Flujo de trabajo recomendado

### 1️ - Exportar `.dacpac` (solo si tienes acceso a la base remota)

Ejecuta:

```bash
tools\backup-dacpac.bat
```

Esto genera un archivo `test_YYYYMMDD_HHMMSS.dacpac` en la carpeta `/releases`.

---

### 2️ - Versionar el `.dacpac` generado

```bash
git add releases\test_YYYYMMDD_HHMMSS.dacpac
git commit -m "feat: nueva versión del esquema"
git push
```

Esto deja el archivo disponible para el resto del equipo.

---

### 3️ - Obtener los últimos cambios

Todos los miembros del equipo deben ejecutar:

```bash
git pull origin main
```

---

### 4️ - Publicar el esquema con el último `.dacpac`

```bash
tools\publish-dacpac.bat
```

Este script detecta automáticamente el `.dacpac` más reciente dentro de `/releases` y lo aplica sobre la base local `test_QA`.

---

### 5 - Aplicar migraciones SQL incrementales

```bash
tools\apply-migrations.bat
```

Ejecuta secuencialmente todos los scripts `.sql` desde la carpeta `/migrations` contra `test_QA`.

---

### 6 - Generar nuevo script `.sql` desde el `.dacpac`

```bash
tools\generate-migration-from-dacpac.bat
```

Esto compara el `.dacpac` con la base `test_QA` y genera un archivo `.sql` en `/migrations`.

Renómbralo y versiona si deseas aplicarlo después:

```bash
git add migrations\006_nueva_migracion.sql
git commit -m "feat: nueva migración"
git push
```

---

## Buenas prácticas

- Nunca edites un `.dacpac` existente. Genera uno nuevo por fecha.
- Usa siempre `/p:BlockOnPossibleDataLoss=True` para evitar pérdidas.
- Versiona scripts `.sql` que ya hayan sido ejecutados o aprobados.
- El repositorio debe contener solo `.dacpac` estables y scripts revisados.

---

## ¿Automatización pendiente?

- Detectar automáticamente el último `.dacpac` para publicar (en progreso).
- Agregar control de migraciones aplicadas mediante un `migrations_log.txt` o tabla de tracking.
