import sys
sshd_config_path = '/etc/ssh/sshd_config'

# TODO
# Handle completely missing lines
# Colorize Passed/Failed?
# Add more tests

POLICY_PERMIT_ROOT_LOGIN= 'yes'
POLICY_PUBKEY_AUTHENTICATION = 'yes'
POLICY_PASSWORD_AUTHENTICATION = 'no'
POLICY_PERMIT_EMPTY_PASSWORDS = 'no'
POLICY_PRINT_MOTD = 'yes'
POLICY_X11FORWARDING = 'no'
POLICY_ALLOW_AGENT_FORWARDING = 'no'

class SshDConfigTests:
    def __init__(self, sshd_config_path):
        self.sshd_config_path = sshd_config_path
        self.number_of_tests = 0
        self.checks_passed = 0
        self.lines = self.read_ssh_config()

    def run_tests(self):
        self.number_of_tests += 1
        if self.check_permit_root_login():
            self.checks_passed += 1
        self.number_of_tests += 1
        if self.check_permit_empty_passwords():
            self.checks_passed += 1
        self.number_of_tests += 1
        if self.check_password_authentication():
            self.checks_passed += 1
        self.number_of_tests += 1
        if self.check_allow_agent_forwarding():
            self.checks_passed += 1
        self.number_of_tests += 1
        if self.check_x11_forwarding():
            self.checks_passed += 1
        self.number_of_tests += 1
        if self.check_print_motd():
            self.checks_passed += 1

    def read_ssh_config(self):
        try:
            with open(self.sshd_config_path, 'r') as file:
                return file.readlines()
        except FileNotFoundError:
            print(f"Error: {self.sshd_config_path} not found.")
            return []

# Tests
# PermitRootLogin
# PubkeyAuthentication
# PermitEmptyPasswords
# PasswordAuthentication
# AllowAgentForwarding
# X11Forwarding
# PrintMotd
    def check_permit_root_login(self):
        for line in self.lines:
            if line.startswith('PermitRootLogin'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_PERMIT_ROOT_LOGIN:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True
            # Check if its not set at all
            elif line.startswith('#PermitRootLogin'):
                print("DEFAULT: ", line)
                return False

    def pub_key_authentication(self):
        for line in self.lines:
            if line.startswith('PubkeyAuthentication'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_PUBKEY_AUTHENTICATION:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True
            elif line.startswith('#PubkeyAuthentication'):
                print("DEFAULT: ", line)
                return False
            else:
                print("PubkeyAuthentication not found in file?")
                return False

    def check_permit_empty_passwords(self):
        for line in self.lines:
            if line.startswith('PermitEmptyPasswords'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_PERMIT_EMPTY_PASSWORDS:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True
            elif line.startswith('#PermitEmptyPasswords'):
                print("DEFAULT: ", line)
                return False

    def check_password_authentication(self):
        for line in self.lines:
            if line.startswith('PasswordAuthentication'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_PASSWORD_AUTHENTICATION:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True
            elif line.startswith('#PermitEmptyPasswords'):
                print("DEFAULT: ", line)
                return False

    def check_allow_agent_forwarding(self):
        for line in self.lines:
            if line.startswith('AllowAgentForwarding'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_ALLOW_AGENT_FORWARDING:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True
            if line.startswith('#PrintMotd'):
                print("DEFAULT: ", line)

    def check_x11_forwarding(self):
        for line in self.lines:
            if line.startswith('X11Forwarding'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_X11FORWARDING:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True

    def check_print_motd(self):
        for line in self.lines:
            if line.startswith('PrintMotd'):
                key = line.split()[1].strip()
                print(line)
                if key.lower() != POLICY_PRINT_MOTD:
                    print("FAILED: ", line)
                    return False
                else:
                    print("PASSED: ", line)
                    return True
            if line.startswith('#PrintMotd'):
                print("DEFAULT: ", line)
                return False


if __name__ == "__main__":
    sshd_config_path = '/etc/ssh/sshd_config'
    sshd_tests_instance = SshDConfigTests(sshd_config_path)

    sshd_tests_instance.run_tests()
    print("Tests passed ", sshd_tests_instance.checks_passed, "/", sshd_tests_instance.number_of_tests)
    if sshd_tests_instance.checks_passed == sshd_tests_instance.number_of_tests:
        print("All checks passed")
        sys.exit(0)
    else:
        print("Some checks failed")
        sys.exit(sshd_tests_instance.number_of_tests - sshd_tests_instance.checks_passed)
