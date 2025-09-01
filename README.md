# e-Mail-pemporario

<img width="322" height="232" alt="image" src="https://github.com/user-attachments/assets/5d2a76ad-c085-4e0c-96e1-a92fedf053eb" />

````markdown
# Mail-Temp 🚀

**Anonymous Temporary Email System**  

Mail-Temp é uma ferramenta Python que permite criar e gerenciar emails temporários de forma rápida e prática. Suporta múltiplos provedores e funcionalidades avançadas como monitoramento de inbox e extração automática de OTPs.

---

## 🔹 Funcionalidades

- Criar email temporário com provedores:
  - MailTM
  - GuerrillaMail
  - 1SecMail
- Auto-seleção do melhor provedor disponível
- Monitorar inbox em tempo real
- Verificar mensagens recebidas
- Extrair OTP automaticamente de emails
- Interface interativa via terminal com animações e banners coloridos

---

## 💻 Requisitos

- Python 3.10 ou superior
- Sistema Linux, macOS ou Windows
- Bibliotecas Python:
  - `requests`
  - `colorama`

---

## ⚡ Instalação

1. Clone o repositório:
```bash
git clone https://github.com/Andrade3162/Mail-Temp.git
cd Mail-Temp
````

2. Crie e ative um ambiente virtual (opcional, mas recomendado):

```bash
python -m venv venv
source venv/bin/activate      # Linux/macOS
venv\Scripts\activate         # Windows
```

3. Instale as dependências:

```bash
pip install requests
pip install -r requirements.txt
```

---

## 🚀 Uso

Execute o programa:

```bash
python TempEmail.py
```

Você verá o menu principal:

```
🚀 Advanced TempMail System
1. Create MailTM Account
2. Create GuerrillaMail Account
3. Create 1SecMail Account
4. Auto-select Best Provider
0. Exit
```

### Menu de Email

Após criar um email, você pode:

1. **Monitorar Inbox** – Receba notificações de novas mensagens em tempo real.
2. **Wait for OTP** – Aguarde automaticamente por um OTP específico.
3. **Check Inbox Once** – Verifique as mensagens recentes sem monitorar continuamente.
4. **Back to Main Menu** – Retornar ao menu principal.

---

## 🎨 Personalização

* Banner colorido e animações para uma experiência visual agradável.
* Velocidade das animações ajustável diretamente no código (`animate_text` e `show_loading_animation`).

---

## ⚠️ Observações

* Emails temporários são voláteis e podem expirar rapidamente.
* O sistema depende de APIs públicas dos provedores, então a disponibilidade pode variar.
* Use com responsabilidade.

---

## 📄 Licença

Este projeto é **open-source**. Pode ser usado e modificado conforme necessidade.

---

## 🔗 Links

* Repositório: [Mail-Temp](https://github.com/Andrade3162/Mail-Temp)

```
---

## ⚠️ Aviso de Isenção de Responsabilidade

Esta ferramenta foi desenvolvida **apenas para fins educacionais e de teste**.  
O autor **não se responsabiliza** pelo uso indevido, ilegal ou malicioso desta aplicação, incluindo, mas não se limitando a:

- Fraudes ou golpes usando emails temporários  
- Acesso não autorizado a contas de terceiros  
- Envio de spam ou conteúdo malicioso  

Ao utilizar este software, você concorda em usá-lo **de forma ética e legal**, respeitando as leis locais e internacionais.

