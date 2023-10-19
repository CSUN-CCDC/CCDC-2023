import sys

USERS = [
        ("admin"),
        ("micheal"),
        ("beep")
        ]


class FileConfigTests:
    def __init__(self, sshd_config_path):
        self.file_config_path = FILE_CONFIG_PATH
        self.number_of_tests = 0
        self.checks_passed = 0
        self.lines = self.read_file_config()

    def run_tests(self):
        for user in USERS:
            if self.check_test_condition(user):
                self.checks_passed += 1

    def read_file_config(self):
        try:
            with open(self.file_config_path, 'r') as file:
                return file.readlines()
        except FileNotFoundError:
            print(f"Error: {self.file_config_path} not found.")
            return []

    def check_test_condition(self, user):
        for line in self.lines:
            self.number_of_tests += 1
            if line.startswith(user):
                print(line.rstrip())
                print("GOOD USER: ", user)
                return True
            else:
                print("BAD USER: ", line.rstrip())


if __name__ == "__main__":
    FILE_CONFIG_PATH = '/etc/passwd'
    file_tests_instance = FileConfigTests(FILE_CONFIG_PATH)

    file_tests_instance.run_tests()
    print("Users cleared", file_tests_instance.checks_passed, "/", file_tests_instance.number_of_tests)
    if file_tests_instance.number_of_tests == file_tests_instance.checks_passed:
        print("All users cleared")
        sys.exit(0)
    else:
        print("Some users bad")
        sys.exit(file_tests_instance.number_of_tests - file_tests_instance.checks_passed)
