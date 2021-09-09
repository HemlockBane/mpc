enum SessionTimeoutReason {
  INACTIVITY, LOGIN_REQUESTED, SESSION_TIMEOUT
}

const INACTIVITY_MESSAGE = "You were automatically logged out to protect your account when we saw no activity. Please re-login to continue";
const LOGIN_REQUESTED_MESSAGE = "A Re-Login was needed for you to continue";
const SESSION_TIMEOUT_MESSAGE = "Your session timed out, please login again to continue.";

const AutoLogoutMessages = const <SessionTimeoutReason, String>{
  SessionTimeoutReason.INACTIVITY: INACTIVITY_MESSAGE,
  SessionTimeoutReason.LOGIN_REQUESTED: LOGIN_REQUESTED_MESSAGE,
  SessionTimeoutReason.SESSION_TIMEOUT: SESSION_TIMEOUT_MESSAGE,
};