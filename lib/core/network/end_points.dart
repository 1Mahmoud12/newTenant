class EndPoints {
  static const domain = 'https://backend.dobzz.com';
  // static const domain = 'https://kadin.dobzz.com';
  static const baseUrl = '$domain/api/v1/';

  // Auth
  static const countryCodes = 'Account/CountryCodes';
  static const register = 'shop/auth/register';
  static const login = 'shop/auth/login';
  static const validateOTP = 'shop/auth/verify-otp-way';
  static const updateFcmToken = 'Account/UpdateFCMToken';
  static const appVisit = 'AppSetting/Admin_UpdateAppVisit';
  static const forgetPassword = 'shop/auth/forgot-password';
  static const resetPassword = 'shop/auth/reset-password';
  static const resendOtp = 'shop/auth/send-otp';
  static const deleteUser = 'Account/DeleteUser';

  // EditProfile
  static const editProfile = 'shop/user/profile';
  static const changePassword = 'Account/ChangePassword';
  static const editPhoneNmber = 'Account/EditPhoneNmber';
  static const validateOTPChangePhone = 'Account/ValidateOTPChangePhone';

  // Address
  static const addAddress = 'Address/AddUserAddress';
  static const editAddress = 'Address/EditUserAddress';
  static const deleteUserAddress = 'Address/DeleteUserAddress';
  static const deleteImageAddress = 'Address/DeleteImage';
  static const getUserAddresses = 'Address/UserAddresses';
  static const setDefaultAddress = 'Address/SetDefaultAddresses';
  static const getNotificationSetting = 'shop/user/settings';

  // Home
  static const getAllBranches = 'Report/GetAllBranches';
  static const staticPage = 'StaticPage/StaticPage';
  static const getAdvertises = 'Advertise/GetAdvertises';
  static const getTopProduct = 'shop/top-products';
  static const search = 'shop/products';
  static const wishlist = 'shop/wishlist';

  //  Service
  static const getCategories = 'shop/categories';
  static const getAllServices = 'Service/GetAllServices';
  static const getAllPetPackages = 'Service/GetAllPetPackages';
  static const slider = 'shop/home';
  static const banner = 'shop/panner-sales';

  //Notification
  static const userNotifications = 'Notification/AllUserNotifications';
  static const readAllNotification = 'Notification/ReadAllUserNotification';
  static const notificationsCount = 'Notification/NotificationsUserCount';
  static const readNotification = 'Notification/ReadNotification';

  //Inbox
  static const getInbox = 'Notification/UserNotifications';
  static const deleteUserInbox = 'Notification/DeleteNotificationByUser';
  static const InboxCount = 'Notification/NotificationsCount';
  static const readInbox = 'Notification/ReadNotification';
  static const readAllInbox = 'Notification/ReadAllNotification';

  //Order
  static const userWallet = 'Order/UserWallet';
  static const getMyOrders = 'Order/GetMyOrders';
  static const getMyRefundOrder = 'Order/GetMyRefundOrders';
  static const getMyCanceledOrders = 'Order/GetMyCanceledOrders';
  static const getOrderDetails = 'Order/GetOrderDetails';
  static const getOrderHistory = 'Order/GetOrderHistory';

  // Cart
  static const addToCart = 'Order/AddToUserCart';
  static const getUserCart = 'Order/GetUserCart';
  static const deleteFromUserCart = 'Order/DeleteFromUserCart';
  static const orderPaymentMethods = 'Order/OrderPaymentMethods';
  static const getOrderInvoice = 'Order/GetOrderInvoice';
  static const proceedOrder = 'Order/ProccedOrder';
  static const timeSlotListPerDay = 'TimeSlot/TimeSlotListPerDay';
  static const addFeedbackList = 'Order/AddFeedbackList';
  static const submitCancellationRequest = 'Order/SubmitCancellationRequest';
  static const getOrderVisitTime = 'Order/GetOrderVisitTime';
  static const cartItems = 'shop/cart';
  static const deleteAccount = 'shop/auth/delete-account';
  static const discount = 'shop/checkout/apply-code';
  static const order = 'shop/orders';
  static const checkoutDetails = 'shop/checkout';
  static const processToCheckout = 'shop/checkout/proceed';
  static const subCategories = 'shop/sub-categories?filter[parent_id]=';

  //Claims
  static const addClaimMessage = 'ClaimMessage/AddClaimMessage';
  static const getClaimByUser = 'ClaimMessage/GetClaimByUser';

  // Announcements
  static const getAnnouncements = 'Announcements/AnnouncementUserList';
  static const deleteUserAnnouncement = 'Announcements/DeleteUserAnnouncement';
  static const readAnnouncement = 'Announcements/ReadAnnouncment';
  static const readAllAnnouncements = 'Announcements/ReadAllAnnouncments';

  // Contact us
  static const contactUs = 'SocialMedia/GetAllActiveSocialMedia';

  // wish list
  static const addToWishList = 'shop/wishlist';

  //product details
  static const getProductDetails = 'shop/products';

  // address
  static const address = 'shop/user/addresses';
  static const state = 'shop/user/states';
  static const cities = '/shop/user/cities?filter[state_id]=';
}
