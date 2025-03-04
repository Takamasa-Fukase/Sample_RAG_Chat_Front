enum AnswerType {
  actionInfo,
  sourceUrlList,
  partOfFinalAnswerText,
  actionInputGenerationCompleted,
  webContentsScrapingProgress,
}

AnswerType getAnswerTypeFromId(int id) {
  switch (id) {
    case 0:
      return AnswerType.actionInfo;
    case 1:
      return AnswerType.sourceUrlList;
    case 2:
      return AnswerType.partOfFinalAnswerText;
    case 4:
      return AnswerType.actionInputGenerationCompleted;
    case 5:
      return AnswerType.webContentsScrapingProgress;
    default:
      throw Exception('想定外のanswerTypeId: $id');
  }
}