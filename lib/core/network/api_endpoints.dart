/// All API path constants.
abstract final class ApiEndpoints {
  // Auth
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String refresh = "/auth/refresh";
  static const String logout = "/auth/logout";

  // User
  static const String me = "/me";

  // Skills
  static const String skills = "/skills";

  // Children
  static const String children = "/children";
  static String child(String id) => "/children/$id";
  static String generateActivity(String childId) =>
      "/children/$childId/activities/generate";
  static String childRecommendation(String childId) =>
      "/children/$childId/recommendations/next";
  static String childProgress(String childId) =>
      "/children/$childId/progress";
  static String childSkillProgress(String childId, String skillId) =>
      "/children/$childId/progress/skills/$skillId";
  static String childSessions(String childId) =>
      "/children/$childId/sessions";

  // Activities & sessions
  static String createSession(String activityId) =>
      "/activities/$activityId/sessions";
  static String submitAnswer(String sessionId) =>
      "/sessions/$sessionId/answers";
  static String completeSession(String sessionId) =>
      "/sessions/$sessionId/complete";
}
