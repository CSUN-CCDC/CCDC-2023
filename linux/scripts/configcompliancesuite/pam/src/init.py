import sys

COMMENT_CHARACTER = "#"


POLICIES = [
        ("password", '[success=1 default=ignore] pam_unix.so obscure yescrypt minlen=12'),
        ]


class FileConfigTests:
    def __init__(self, sshd_config_path):
        self.file_config_path = FILE_CONFIG_PATH
        self.number_of_tests = 0
        self.checks_passed = 0
        self.lines = self.read_file_config()

    def run_tests(self):
        for policy_string, policy_option in POLICIES:
            if self.check_test_condition(policy_string, policy_option):
                self.checks_passed += 1

    def read_file_config(self):
        try:
            with open(self.file_config_path, 'r') as file:
                return file.readlines()
        except FileNotFoundError:
            print(f"Error: {self.file_config_path} not found.")
            return []

    def check_test_condition(self, POLICY_STRING, POLICY_OPTION):
        self.number_of_tests += 1
        comment_string = COMMENT_CHARACTER + POLICY_STRING
        for line in self.lines:
            if line.startswith(POLICY_STRING):
                key = line.split()[1].strip()
                print(line.rstrip())
                if key.lower() != POLICY_OPTION:
                    print("FAILED: ", line.rstrip())
                    print("The correct value should be: ", POLICY_OPTION)
                    return False
                else:
                    print("PASSED: ", line.rstrip())
                    return True
            elif line.startswith(comment_string):
                print("DEFAULT: ", line.rstrip())
                print("The correct value should be: ", POLICY_OPTION)
                return False
        print("MISSING: ", POLICY_STRING)
        return False


if __name__ == "__main__":
    FILE_CONFIG_PATH = '/etc/pam.d/common-password'
    file_tests_instance = FileConfigTests(FILE_CONFIG_PATH)

    file_tests_instance.run_tests()
    print("Checks passed ", file_tests_instance.checks_passed, "/", file_tests_instance.number_of_tests)
    if file_tests_instance.number_of_tests == file_tests_instance.checks_passed:
        print("All checks passed")
        sys.exit(0)
    else:
        print("Some checks failed")
        sys.exit(file_tests_instance.number_of_tests - file_tests_instance.checks_passed)
