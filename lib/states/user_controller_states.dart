enum UserControllerGetUserProfileDataStates {
  InitialState,
  LoadingState,
  LoadedState,
  ErrorState,
}

enum UserControllerCreatePostStates { LoadingState, SuccessState, ErrorState }

enum UserControllerGetPostsStates {
  InitialState,
  LoadingState,
  LoadedState,
  ErrorState
}

enum UserControllerPickPostImageStates {
  PostImagePickedSuccessState,
  PostImagePickedErrorState
}

enum UserControllerPickProfileImagesStates {
  ProfileImagePickedSuccessState,
  ProfileImagePickedErrorState,
  CoverImagePickedSuccessState,
  CoverImagePickedErrorState
}

enum UserControllerUploadImageStates{
  UploadProfileImageLoadingState,
  UploadProfileImageSuccessState,
  UploadProfileImageErrorState,
  UploadCoverImageLoadingState,
  UploadCoverImageSuccessState,
  UploadCoverImageErrorState
}

enum UserControllerUpdateDataStates{
  InitialState,
  LoadingState,
  LoadedState,
  ErrorState,
}