class Urls {
  Urls._();
  static String baseUrl = "https://task.teamrabbil.com/api/v1";
  static String registration = "$baseUrl/registration";
  static String login = "$baseUrl/login";
  static String createTask = "$baseUrl/createTask";
  static String taskStatusCount = "$baseUrl/taskStatusCount";
  static String listTaskByStatusNew = "$baseUrl/listTaskByStatus/New";
  static String listTaskByStatusProgress = "$baseUrl/listTaskByStatus/Pregress";
  static String deleteTask(String id) => "$baseUrl/deleteTask/$id";
  static String updateTask(String id, String status) => "$baseUrl/updateTaskStatus/$id/$status";
  static String updateProfile = "$baseUrl/profileUpdate";
  static String sendOTPtoEmail(String email) => "$baseUrl/RecoverVerifyEmail/$email";
  static String verifyOTP(String email, String otp) => "$baseUrl/RecoverVerifyOTP/$email/$otp";
  static String resetPassword = "$baseUrl/RecoverResetPass";

}