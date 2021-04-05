class Language{
  final int id;
  final String name;
  final String flaf;
  final String languageCode;
  Language(this.id,this.name,this.flaf,this.languageCode);

  static List<Language> languageList(){
    return <Language>[
      Language(1, 'English', '🇮🇳', 'en'),
      Language(2, 'हिन्दी', '🇮🇳', 'hi'),
    ];
  }
}