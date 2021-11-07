enum CommentControllerPickCommentImage {
  CommentImagePickedSuccessState,
  CommentImagePickedErrorState,
}

enum CommentControllerUploadCommentImageStates {
  UploadCommentImageSuccessState,
  UploadCommentImageErrorState,
}

enum CommentControllerCreateCommentOnPost {
  LoadingState,
  SuccessState,
  ErrorState
}

enum CommentControllerGetComments{
  InitialState,
  LoadingState,
  LoadedState,
  ErrorState
}