class UserModel:
    def __init__(self, username, name, role):
        self.username = username
        self.name = name
        self.role = role

    def to_dict(self):
        return {
            "username": self.username,
            "name": self.name,
            "role": self.role,
        }