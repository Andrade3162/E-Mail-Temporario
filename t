
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
banner = """
\033[1;36m
 █████╗ ███╗   ██╗██████╗ ██████╗ ██████╗ ███████╗
██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝
███████║██╔██╗ ██║██║  ██║██║  ██║██║  ██║█████╗  
██╔══██║██║╚██╗██║██║  ██║██║  ██║██║  ██║██╔══╝  
██║  ██║██║ ╚████║██████╔╝██████╔╝██████╔╝███████╗
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
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
"""
print(banner)

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
        """Create mail.tm account"""
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
        """Create GuerrillaMail address"""
        try:
            response = self.session.get(
                self.providers['guerrillamail']['create']
            )
            data = response.json()
            self.email = data['email_addr']
            return True
        except:
            return False

    def _create_1secmail(self):
        """Generate 1secmail address"""
        try:
            domains = ["1secmail.com", "1secmail.net", "1secmail.org"]
            self.email = f"{self._random_string()}@{random.choice(domains)}"
            return True
        except:
            return False

    def check_inbox(self, limit=5, unread_only=False):
        """Check inbox with advanced options"""
        if not self.email:
            self.animate_text("\033[1;33mNo email address created yet\033[0m", speed=0.03)
            return []

        method = getattr(self, f'_check_{self.current_provider}', None)
        if method:
            return method(limit=limit, unread_only=unread_only)
        return []

    def _check_mailtm(self, limit=5, unread_only=False):
        """Check mail.tm inbox"""
        try:
            response = self.session.get(
                self.providers['mailtm']['messages']
            )
            messages = response.json().get('hydra:member', [])
            
            if unread_only:
                messages = [msg for msg in messages if not msg.get('isRead', True)]
            
            return messages[:limit]
        except Exception as e:
            self.animate_text(f"\033[1;31m[MailTM] Inbox error: {str(e)}\033[0m", speed=0.03)
            return []

    def _check_guerrillamail(self, limit=5, unread_only=False):
        """Check GuerrillaMail inbox"""
        try:
            local_part = self.email.split('@')[0]
            sid_parts = local_part.split('-')
            sid = sid_parts[-1]
            
            params = {
                'f': 'get_email_list',
                'offset': 0,
                'sid_token': sid
            }
            response = self.session.get(
                self.providers['guerrillamail']['messages'],
                params=params
            )
            data = response.json()
            
            if 'list' not in data:
                self.animate_text("\033[1;31m[GuerrillaMail] Invalid response format\033[0m", speed=0.03)
                return []
                
            messages = data['list']
            
            if unread_only:
                messages = [msg for msg in messages if msg.get('mail_read', 0) == 0]
            
            return messages[:limit]
        except Exception as e:
            self.animate_text(f"\033[1;31m[GuerrillaMail] Inbox error: {str(e)}\033[0m", speed=0.03)
            return []

    def _check_1secmail(self, limit=5, unread_only=False):
        """Check 1secmail inbox"""
        try:
            username, domain = self.email.split('@')
            response = self.session.get(
                f"{self.providers['1secmail']['messages']}?action=getMessages&login={username}&domain={domain}"
            )
            messages = response.json()
            return messages[:limit]
        except Exception as e:
            self.animate_text(f"\033[1;31m[1SecMail] Inbox error: {str(e)}\033[0m", speed=0.03)
            return []

    def get_message_content(self, message_id):
        """Get full message content"""
        if self.current_provider == 'mailtm':
            try:
                response = self.session.get(
                    f"{self.providers['mailtm']['messages']}/{message_id}"
                )
                return response.json().get('text', '')
            except Exception as e:
                self.animate_text(f"\033[1;31m[MailTM] Message error: {str(e)}\033[0m", speed=0.03)
        
        elif self.current_provider == 'guerrillamail':
            try:
                local_part = self.email.split('@')[0]
                sid = local_part.split('-')[-1]
                
                params = {
                    'f': 'fetch_email',
                    'email_id': message_id,
                    'sid_token': sid
                }
                response = self.session.get(
                    self.providers['guerrillamail']['messages'],
                    params=params
                )
                return response.json().get('mail_body', '')
            except Exception as e:
                self.animate_text(f"\033[1;31m[GuerrillaMail] Message error: {str(e)}\033[0m", speed=0.03)
        
        elif self.current_provider == '1secmail':
            try:
                username, domain = self.email.split('@')
                response = self.session.get(
                    f"{self.providers['1secmail']['messages']}?action=readMessage&login={username}&domain={domain}&id={message_id}"
                )
                return response.json().get('textBody', '')
            except Exception as e:
                self.animate_text(f"\033[1;31m[1SecMail] Message error: {str(e)}\033[0m", speed=0.03)
        
        return ""

    def extract_otp(self, text, length=6):
        """Extract OTP from text with multiple patterns"""
        patterns = [
            r'\b\d{' + str(length) + r'}\b',
            r'code[:\s-]*(\d{' + str(length) + r'})',
            r'verification[^\d]*(\d{' + str(length) + r'})',
            r'one-time[^\d]*(\d{' + str(length) + r'})',
            r'OTP[^\d]*(\d{' + str(length) + r'})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1)
        return None

    def wait_for_otp(self, timeout=300, interval=10, expected_sender=None):
        """Automatically wait for OTP to arrive"""
        start_time = time.time()
        self.animate_text(f"\n\033[1;36m⌛ Waiting for OTP (timeout: {timeout}s)...\033[0m", speed=0.03)
        
        while time.time() - start_time < timeout:
            messages = self.check_inbox(unread_only=True)
            
            for msg in messages:
                if expected_sender and expected_sender.lower() not in str(msg.get('from', '')).lower():
                    continue
                
                content = self.get_message_content(msg.get('id', ''))
                otp = self.extract_otp(content)
                
                if otp:
                    self.animate_text(f"\n\033[1;32m🎉 OTP found: \033[1;33m{otp}\033[0m", speed=0.03)
                    print(f"\033[1;37mFrom: {msg.get('from', 'Unknown')}\033[0m")
                    return otp
            
            sys.stdout.write("\033[1;33m⏳\033[0m")
            sys.stdout.flush()
            time.sleep(interval)
        
        self.animate_text("\n\033[1;31m⌛ OTP not received within timeout period\033[0m", speed=0.03)
        return None

    def animate_text(self, text, speed=0.05):
        """Animate text printing"""
        for char in text:
            sys.stdout.write(char)
            sys.stdout.flush()
            time.sleep(speed)
        print()

    def _random_string(self, length=10):
        """Generate random string"""
        chars = string.ascii_lowercase + string.digits
        return ''.join(random.choice(chars) for _ in range(length))

    def show_menu(self):
        """Display animated menu"""
        self.animate_text("\n\033[1;36m🚀 Advanced TempMail System\033[0m", speed=0.03)
        self.animate_text("\033[1;37m1. Create MailTM Account\033[0m", speed=0.03)
        self.animate_text("\033[1;37m2. Create GuerrillaMail Account\033[0m", speed=0.03)
        self.animate_text("\033[1;37m3. Create 1SecMail Account\033[0m", speed=0.03)
        self.animate_text("\033[1;37m4. Auto-select Best Provider\033[0m", speed=0.03)
        self.animate_text("\033[1;31m0. Exit\033[0m", speed=0.03)

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
            
        provider_map = {
            '1': 'mailtm',
            '2': 'guerrillamail',
            '3': '1secmail',
            '4': None
        }
        
        if choice in provider_map:
            selected_provider = provider_map[choice]
            if system.create_email(preferred_provider=selected_provider):
                while True:
                    system.animate_text("\n\033[1;36m✉️ Email Management\033[0m", speed=0.03)
                    system.animate_text("\033[1;37m1. Monitor Inbox\033[0m", speed=0.03)
                    system.animate_text("\033[1;37m2. Wait for OTP\033[0m", speed=0.03)
                    system.animate_text("\033[1;37m3. Check Inbox Once\033[0m", speed=0.03)
                    system.animate_text("\033[1;31m4. Back to Main Menu\033[0m", speed=0.03)
                    
                    sub_choice = input("\n\033[1;37mSelect option (1-4): \033[0m").strip()
                    
                    if sub_choice == '1':
                        system.animate_text("\n\033[1;36m🔍 Monitoring inbox... (Ctrl+C to stop)\033[0m", speed=0.03)
                        try:
                            while True:
                                messages = system.check_inbox(limit=3)
                                if messages:
                                    system.animate_text("\n\033[1;36m=== Inbox ===\033[0m", speed=0.03)
                                    for i, msg in enumerate(messages, 1):
                                        print(f"\n\033[1;37mMessage {i}:\033[0m")
                                        print(f"\033[1;34mFrom: \033[0m{msg.get('from', 'Unknown')}")
                                        print(f"\033[1;34mSubject: \033[0m{msg.get('subject', 'No subject')}")
                                        
                                        if input("\033[1;37mView content? (y/n): \033[0m").lower() == 'y':
                                            content = system.get_message_content(msg.get('id', ''))
                                            print("\n\033[1;36mContent:\033[0m")
                                            print(content[:500] + ("..." if len(content) > 500 else ""))
                                            
                                            otp = system.extract_otp(content)
                                            if otp:
                                                print(f"\n\033[1;32m🎯 Detected OTP: \033[1;33m{otp}\033[0m")
                                else:
                                    system.animate_text("\n\033[1;33m📭 No new messages\033[0m", speed=0.03)
                                
                                time.sleep(10)
                        except KeyboardInterrupt:
                            system.animate_text("\n\033[1;31m🛑 Stopped monitoring\033[0m", speed=0.03)
                    
                    elif sub_choice == '2':
                        expected_sender = input("\033[1;37mEnter expected sender (optional, e.g., 'no-reply@service.com'): \033[0m").strip()
                        otp = system.wait_for_otp(expected_sender=expected_sender if expected_sender else None)
                        if otp:
                            print(f"\n\033[1;32m✨ Use this OTP: \033[1;33m{otp}\033[0m")
                    
                    elif sub_choice == '3':
                        messages = system.check_inbox(limit=5)
                        if messages:
                            system.animate_text("\n\033[1;36m=== Latest Messages ===\033[0m", speed=0.03)
                            for msg in messages:
                                print(f"\n\033[1;34mFrom: \033[0m{msg.get('from', 'Unknown')}")
                                print(f"\033[1;34mSubject: \033[0m{msg.get('subject', 'No subject')}")
                        else:
                            system.animate_text("\n\033[1;33m📭 No messages found\033[0m", speed=0.03)
                    
                    elif sub_choice == '4':
                        break
                    
                    else:
                        system.animate_text("\033[1;31mInvalid choice, please try again\033[0m", speed=0.03)
        else:
            system.animate_text("\033[1;31mInvalid choice, please try again\033[0m", speed=0.03)

if __name__ == "__main__":
    main()

