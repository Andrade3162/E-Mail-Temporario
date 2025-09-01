import requests
import random
import string
import time
import re
import sys
from datetime import datetime

class TempMailPro:
    def __init__(self):
        self.email = ""
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/json',
        })
        self.current_provider = None
        self.providers = {
            'mailtm': {
                'name': 'MailTM',
                'create': 'https://api.mail.tm/accounts',
                'messages': 'https://api.mail.tm/messages',
                'auth': None
            },
            'guerrillamail': {
                'name': 'GuerrillaMail',
                'create': 'https://api.guerrillamail.com/ajax.php?f=get_email_address',
                'messages': 'https://api.guerrillamail.com/ajax.php?f=get_email_list',
                'auth': 'sid_token'
            },
            '1secmail': {
                'name': '1SecMail',
                'create': None,
                'messages': 'https://www.1secmail.com/api/v1/',
                'auth': None
            }
        }

    def show_banner(self):
        """Display the banner with updated color scheme"""
        banner = """

\033[1;33m
████████╗███████╗███╗   ███╗██████╗ 
╚══██╔══╝██╔════╝████╗ ████║██╔══██╗
   ██║   █████╗  ██╔████╔██║██████╔╝
   ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝    
   ██║   ███████╗██║ ╚═╝ ██║██║          
   ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     
\033[1;33m
███████╗███╗   ███╗ █████╗ ██╗██╗     
██╔════╝████╗ ████║██╔══██╗██║██║     
█████╗  ██╔████╔██║███████║██║██║     
██╔══╝  ██║╚██╔╝██║██╔══██║██║██║     
███████╗██║ ╚═╝ ██║██║  ██║██║███████╗
╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝
\033[0m
"""
        print(banner)
        print("\033[1;35m╔════════════════════════════════════════════════════╗")
        print("\033[1;35m║         \033[1;36mAnonymous Temporary Email System\033[1;35m           ║")
        print("\033[1;35m║         \033[1;33mVersion: 1.1\033[1;35m                               ║")
        print("\033[1;35m║         \033[1;32mAuthor : East Timor Ghost Security\033[1;35m         ║")
        print("\033[1;35m╚════════════════════════════════════════════════════╝\033[0m\n")

    def show_loading_animation(self, duration=3):
        """Show box loading animation"""
        frames = ["[▯▯▯▯▯]", "[▮▯▯▯▯]", "[▮▮▯▯▯]", "[▮▮▮▯▯]", "[▮▮▮▮▯]", "[▮▮▮▮▮]"]
        colors = [91, 93, 92]  # Red, Yellow, Green
        print("\n\033[1;36mInitializing temporary email system...\033[0m")
        for i in range(duration * 2):
            frame_idx = i % len(frames)
            color_idx = 0
            if frame_idx > 2: color_idx = 1
            if frame_idx > 4: color_idx = 2
            sys.stdout.write(f"\r\033[1;37mLoading: \033[0m\033[1;{colors[color_idx]}m{frames[frame_idx]}\033[0m ")
            sys.stdout.flush()
            time.sleep(0.5)
        print("\n\033[1;32mSystem ready!\033[0m\n")

    def create_email(self, preferred_provider=None):
        """Create temporary email with fallback providers"""
        self.show_loading_animation()
        providers_order = ['mailtm', 'guerrillamail', '1secmail']
        if preferred_provider and preferred_provider in providers_order:
            providers_order.remove(preferred_provider)
            providers_order.insert(0, preferred_provider)
        for provider in providers_order:
            method = getattr(self, f'_create_{provider}')
            if method():
                self.current_provider = provider
                self.animate_text(f"\033[1;32m✓ {self.providers[provider]['name']} account created\033[0m", speed=0.05)
                self.animate_text(f"\033[1;36mYour temp email: \033[1;33m{self.email}\033[0m", speed=0.03)
                return True
        self.animate_text("\033[1;31m✗ Failed to create email with all providers\033[0m", speed=0.05)
        return False

    def _create_mailtm(self):
        try:
            username = f"{self._random_string()}@gmail.com"
            password = self._random_string(16)
            response = self.session.post(
                self.providers['mailtm']['create'],
                json={"address": username, "password": password}
            )
            if response.status_code == 201:
                self.email = response.json()['address']
                return True
        except:
            return False

    def _create_guerrillamail(self):
        try:
            response = self.session.get(self.providers['guerrillamail']['create'])
            data = response.json()
            self.email = data['email_addr']
            return True
        except:
            return False

    def _create_1secmail(self):
        try:
            domains = ["1secmail.com", "1secmail.net", "1secmail.org"]
            self.email = f"{self._random_string()}@{random.choice(domains)}"
            return True
        except:
            return False

    # Aqui continuam todos os outros métodos (check_inbox, get_message_content, wait_for_otp, etc.)
    # Mantendo a mesma indentação para dentro da classe.

    def animate_text(self, text, speed=0.05):
        for char in text:
            sys.stdout.write(char)
            sys.stdout.flush()
            time.sleep(speed)
        print()

    def _random_string(self, length=10):
        chars = string.ascii_lowercase + string.digits
        return ''.join(random.choice(chars) for _ in range(length))

    def show_menu(self):
        self.animate_text("\n\033[1;36m🚀 Advanced TempMail System\033[0m", speed=0.03)
        self.animate_text("\033[1;37m1. Create MailTM Account\033[0m", speed=0.03)
        self.animate_text("\033[1;37m2. Create GuerrillaMail Account\033[0m", speed=0.03)
        self.animate_text("\033[1;37m3. Create 1SecMail Account\033[0m", speed=0.03)
        self.animate_text("\033[1;37m4. Auto-select Best Provider\033[0m", speed=0.03)
        self.animate_text("\033[1;31m0. Exit\033[0m", speed=0.03)

# ---------------- Main Program ----------------
def main():
    system = TempMailPro()
    system.show_banner()
    while True:
        system.show_menu()
        choice = input("\n\033[1;37mSelect option (0-4): \033[0m").strip()
        if choice == '0':
            system.animate_text("\n\033[1;31m🔌 Shutting down system...\033[0m", speed=0.05)
            time.sleep(1)
            break
        # Aqui você pode manter o mesmo código do menu e submenus.

if __name__ == "__main__":
    main()
