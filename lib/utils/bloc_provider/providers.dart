import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/auth/bloc/login/login_cubit.dart';
import 'package:elite/feature/auth/bloc/register_user/register_user_cubit.dart';
import 'package:elite/feature/home_screen/bloc/check_rental/check_rental_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_highlighted/highlighted_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_avg_rating/get_avg_rating_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_cast_crew/get_cast_crew_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_highlighted_content/get_highlighted_content_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_live_by_category/get_live_by_category_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_most_viewed/get_most_viewed_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_movie_by_category_id/get_movie_by_category_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_movie_by_id/get_movie_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_series_cast_crew/get_series_castcrew_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_shortfilm_id/get_shortfilm_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_webseries_by_id/get_webseries_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/payment_history/payment_history_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_continue_watching/post_continue_watching_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_like/post_like_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_movie_rating/post_movie_rating_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_rent/post_rent_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_report/post_report_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_watchlist/post_watchlist_cubit.dart';
import 'package:elite/feature/home_screen/bloc/service_rating/get_series_rating/get_series_rating_cubit.dart';
import 'package:elite/feature/home_screen/bloc/service_rating/post_series_rating/post_series_rating_cubit.dart';
import 'package:elite/feature/home_screen/bloc/shortfilm-rating/get_short_film_rating_by_id/get_short_film_rating_by_id_cubit.dart';
import 'package:elite/feature/home_screen/bloc/shortfilm-rating/short_film_rate/short_film_rate_cubit.dart';
import 'package:elite/feature/music/bloc/add_song_in_playlist/add_song_in_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/choose_for_you/post_choose_for_you_cubit.dart';
import 'package:elite/feature/music/bloc/delete_playlist/delete_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_language/get_all_language_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite/feature/music/bloc/get_artist/get_artist_cubit.dart';
import 'package:elite/feature/music/bloc/get_choose_for_you/get_choose_for_you_cubit.dart';
import 'package:elite/feature/music/bloc/get_playlist/get_all_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/get_popular_music/get_popular_music_cubit.dart';
import 'package:elite/feature/music/bloc/post_playlist/post_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/update_watched_count/update_watched_count_cubit.dart';
import 'package:elite/feature/profile/bloc/change_password/change_password_cubit.dart';
import 'package:elite/feature/profile/bloc/forget_password/forget_password_cubit.dart';
import 'package:elite/feature/profile/bloc/get_rental_by_userid/get_rental_by_userid_cubit.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_cubit.dart';
import 'package:elite/feature/profile/bloc/get_watchlist/get_watchlist_cubit.dart';
import 'package:elite/feature/profile/bloc/logout/logout_cubit.dart';
import 'package:elite/feature/profile/bloc/update_profile/update_profile_cubit.dart';
import 'package:elite/feature/search/bloc/get_resent_search/get_resent_search_cubit.dart';
import 'package:elite/feature/search/bloc/post_resent_search/post_resent_serch_cubit.dart';
import 'package:provider/single_child_widget.dart';
import '../../feature/home_screen/bloc/get_like/get_like_cubit.dart';
import '../../feature/home_screen/bloc/get_short_film_castcrew/get_short_film_castcrew_cubit.dart';
import '../../feature/music/bloc/get_all_music/get_all_music_cubit.dart';
import '../../feature/music/bloc/get_data_by_artist_and_language/get_data_by_artist_and_language_cubit.dart';
import '../../feature/profile/bloc/create_order/create_order_cubit.dart';
import '../../feature/search/bloc/get_all_category/get_all_category_cubit.dart';
import '../../feature/search/bloc/get_live_category/get_live_category_cubit.dart';
import '../../feature/search/bloc/search/search_cubit.dart';
import '../../feature/trailer/get_all_trailer/get_all_trailer_cubit.dart';

List<SingleChildWidget> providers = [
  BlocProvider(create: (context) => LoginCubit()),
  BlocProvider(create: (context) => RegisterUserCubit()),
  BlocProvider(create: (context) => GetAllMovieCubit()),
  BlocProvider(create: (context) => HighlightedMovieCubit()),
  BlocProvider(create: (context) => GetMostViewedCubit()),
  BlocProvider(create: (context) => GetProfileCubit()),
  BlocProvider(create: (context) => GetCastCrewCubit()),
  BlocProvider(create: (context) => PostWatchlistCubit()),
  BlocProvider(create: (context) => GetWatchlistCubit()),
  BlocProvider(create: (context) => UpdateProfileCubit()),
  BlocProvider(create: (context) => GetSettingCubit()),
  BlocProvider(create: (context) => GetSubscriptionCubit()),
  BlocProvider(create: (context) => GetAllMusicCategoryCubit()),
  BlocProvider(create: (context) => GetAllMusicCubit()),
  BlocProvider(create: (context) => GetAllShortFilmCubit()),
  BlocProvider(create: (context) => GetAllSeriesCubit()),
  BlocProvider(create: (context) => GetAllEpisodeCubit()),
  BlocProvider(create: (context) => PostMovieRatingCubit()),
  BlocProvider(create: (context) => GetAvgRatingCubit()),
  BlocProvider(create: (context) => PostReportCubit()),
  BlocProvider(create: (context) => ChangePasswordCubit()),
  BlocProvider(create: (context) => ForgetPasswordCubit()),
  BlocProvider(create: (context) => ShortFilmRateCubit()),
  BlocProvider(create: (context) => GetShortFilmRatingByIdCubit()),
  BlocProvider(create: (context) => GetSeriesRatingCubit()),
  BlocProvider(create: (context) => PostSeriesRatingCubit()),
  BlocProvider(create: (context) => GetShortFilmCastcrewCubit()),
  BlocProvider(create: (context) => GetSeriesCastcrewCubit()),
  BlocProvider(create: (context) => PostRentCubit()),
  BlocProvider(create: (context) => GetRentalByUseridCubit()),
  BlocProvider(create: (context) => PostContinueWatchingCubit()),
  BlocProvider(create: (context) => GetContinueWatchingCubit()),
  BlocProvider(create: (context) => LogoutCubit()),
  BlocProvider(create: (context) => GetLikeCubit()),
  BlocProvider(create: (context) => PostLikeCubit()),
  BlocProvider(create: (context) => GetMovieByIdCubit()),
  BlocProvider(create: (context) => GetShortfilmByIdCubit()),
  BlocProvider(create: (context) => SearchCubit()),
  BlocProvider(create: (context) => CheckRentalCubit()),
  BlocProvider(create: (context) => CreateOrderCubit()),
  BlocProvider(create: (context) => GetWebseriesByIdCubit()),
  BlocProvider(create: (context) => GetLiveTvCubit()),
  BlocProvider(create: (context) => GetHighlightedContentCubit()),
  BlocProvider(create: (context) => PaymentHistoryCubit()),
  BlocProvider(create: (context) => GetAllTvShowSeriesCubit()),
  BlocProvider(create: (context) => GetPopularMusicCubit()),
  BlocProvider(create: (context) => GetAllLanguageCubit()),
  BlocProvider(create: (context) => GetArtistCubit()),
  BlocProvider(create: (context) => GetDataByArtistAndLanguageCubit()),
  BlocProvider(create: (context) => UpdateWatchedCountCubit()),
  BlocProvider(create: (context) => PostChooseForYouCubit()),
  BlocProvider(create: (context) => GetChooseForYouCubit()),
  BlocProvider(create: (context) => GetLiveCategoryCubit()),
  BlocProvider(create: (context) => GetAllMovieCategoryCubit()),
  BlocProvider(create: (context) => GetResentSearchCubit()),
  BlocProvider(create: (context) => PostResentSerchCubit()),
  BlocProvider(create: (context) => GetMovieByCategoryIdCubit()),
  BlocProvider(create: (context) => GetLiveByCategoryIdCubit()),
  BlocProvider(create: (context) => PostPlaylistCubit()),
  BlocProvider(create: (context) => GetAllPlaylistCubit()),
  BlocProvider(create: (context) => DeletePlaylistCubit()),
  BlocProvider(create: (context) => AddSongInPlaylistCubit()),
  BlocProvider(create: (context) => GetAllTrailerCubit()),
];
