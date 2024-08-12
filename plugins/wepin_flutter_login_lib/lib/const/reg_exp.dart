const String bcryptSalt = r'$2a$10$QCJoWqnN.acrjPIgKYCthu';
final RegExp emailRegExp = RegExp(
  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
  caseSensitive: false,
);
final RegExp passwordRegExp = RegExp(
  r"^(?=.*[a-zA-Z])(?=.*[0-9]).{8,128}$",
);