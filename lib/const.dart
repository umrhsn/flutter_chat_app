// ignore_for_file: non_constant_identifier_names

final RegExp EMAIL_VALIDATION_REGEX = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

final RegExp PASSWORD_VALIDATION_REGEX = RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[a-zA-Z]).{8,}$");

final RegExp NAME_VALIDATION_REGEX = RegExp(r"\b([A-Za-zÀ-ÿ][-,'a-z. ]{1,})");

final String PLACEHOLDER_PFP =
    "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQk0xQgDQEELoTuERQ45SsWV.jpg";
