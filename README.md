![1](https://github.com/user-attachments/assets/265644fa-b148-44b8-ae3c-39aedd593f7b)
![2](https://github.com/user-attachments/assets/b7b06f9d-352b-438f-adbe-002d6ff5699f)


# 💈 Barbershop App + Backend Node.js

Este projeto é composto por duas partes principais:

1. **Frontend Flutter** – Um aplicativo gerenciamento de barbearias.
2. **Backend Node.js + PostgreSQL** – API RESTful para comunicação e persistência de dados.

---

## ✂️ Funcionalidades do App Flutter

- Autenticação de usuários com persistência (`shared_preferences`)
- Navegação e estado com `provider`
- Agendamento com datas (📅 `syncfusion_flutter_datepicker` e `date_picker_timeline`)
- Upload de imagens (`image_picker`)
- Ícones e animações: (`emoji_picker_flutter`, `flutter_spinkit`, `ionicons`, `font_awesome_flutter`, `material_design_icons_flutter`)
- Layout (`google_fonts`, `iconsax` e `social_media_buttons`)
- Validação de formulários com `validatorless`
- Internacionalização com `intl`

### 📂 Assets utilizados

```
assets/images/
├── logo.jpeg
├── logo1.jpeg
├── logo2.jpeg
├── logo3.jpeg
└── blank-profile.png
```

## 🚀 Como rodar o App Flutter

1. **Clone o projeto:**
   ```bash
   git clone https://github.com/seu-usuario/barbershop.git
   cd barbershop
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto:**
   ```bash
   flutter run
   ```

> Certifique-se de que um emulador ou dispositivo esteja conectado.

---

## 🧠 Backend Node.js + PostgreSQL

### 📦 Tecnologias

- `express`, `cors`, `multer`
- `pg` e `postgres` para conexão com banco PostgreSQL
- `.env` com `dotenv` para variáveis de ambiente

### 📁 Scripts úteis

```json
"scripts": {
  "start": "node index.js",
  "dev": "node --watch --no-warnings index.js"
}
```

### ▶️ Como rodar o backend

1. **Instale as dependências:**
   ```bash
   npm install
   ```

2. **Configure o arquivo `.env`:**
   ```env
   DATABASE_URL=postgresql://usuario:senha@localhost:5432/nome_do_banco
   ```

3. **Inicie o servidor em modo de desenvolvimento:**
   ```bash
   npm run dev
   ```

---
Atualizado em 29 de julho de 2025.



