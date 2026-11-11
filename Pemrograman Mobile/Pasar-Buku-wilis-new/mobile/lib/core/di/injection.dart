import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/buku/data/datasources/buku_local_datasource.dart';
import '../../features/buku/data/datasources/buku_remote_datasource.dart';
import '../../features/buku/data/repositories/buku_repository_impl.dart';
import '../../features/buku/domain/repositories/buku_repository.dart';
import '../../features/buku/domain/usecases/create_buku_usecase.dart';
import '../../features/buku/domain/usecases/get_buku_list_usecase.dart';
import '../../features/buku/domain/usecases/get_buku_temuan_usecase.dart';
import '../../features/buku/domain/usecases/get_kategori_ringkas_usecase.dart';
import '../../features/buku/domain/usecases/get_kategori_tematik_usecase.dart';
import '../../features/buku/presentation/viewmodels/stok_kategori_viewmodel.dart';
import '../../features/forum/data/datasources/forum_local_datasource.dart';
import '../../features/forum/data/repositories/forum_repository_impl.dart';
import '../../features/forum/domain/repositories/forum_repository.dart';
import '../../features/forum/domain/usecases/create_post_usecase.dart';
import '../../features/forum/domain/usecases/get_posts_usecase.dart';
import '../../features/forum/domain/usecases/toggle_like_usecase.dart';
import '../../features/forum/presentation/viewmodels/forum_viewmodel.dart';
import '../../features/kios/data/datasources/kios_local_datasource.dart';
import '../../features/kios/data/repositories/kios_repository_impl.dart';
import '../../features/kios/domain/repositories/kios_repository.dart';
import '../../features/kios/domain/usecases/get_buku_populer_usecase.dart';
import '../../features/kios/domain/usecases/get_daftar_kios_usecase.dart';
import '../../features/kios/domain/usecases/get_fasilitas_usecase.dart';
import '../../features/kios/presentation/viewmodels/denah_viewmodel.dart';
import '../../features/tentang/data/datasources/tentang_local_datasource.dart';
import '../../features/tentang/data/repositories/tentang_repository_impl.dart';
import '../../features/tentang/domain/repositories/tentang_repository.dart';
import '../../features/tentang/presentation/viewmodels/tentang_viewmodel.dart';

class Injection {
  Injection._();

  static final Map<Type, dynamic> _instances = {};
  static final Map<Type, dynamic Function()> _factories = {};

  static void registerSingleton<T>(T instance) {
    _instances[T] = instance;
  }

  static void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  static T get<T>() {
    if (_instances.containsKey(T)) {
      return _instances[T] as T;
    }
    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }
    throw Exception('Object of type $T is not registered in Injection container.');
  }

  static void init() {
    // ----------------- DATA SOURCES -----------------
    final authLocalDataSource = AuthLocalDataSourceImpl();
    registerSingleton<AuthLocalDataSource>(authLocalDataSource);

    final bukuRemoteDataSource = BukuRemoteDataSourceImpl();
    registerSingleton<BukuRemoteDataSource>(bukuRemoteDataSource);

    final bukuLocalDataSource = BukuLocalDataSourceImpl();
    registerSingleton<BukuLocalDataSource>(bukuLocalDataSource);

    final kiosLocalDataSource = KiosLocalDataSourceImpl();
    registerSingleton<KiosLocalDataSource>(kiosLocalDataSource);

    final forumLocalDataSource = ForumLocalDataSourceImpl();
    registerSingleton<ForumLocalDataSource>(forumLocalDataSource);

    final tentangLocalDataSource = TentangLocalDataSourceImpl();
    registerSingleton<TentangLocalDataSource>(tentangLocalDataSource);

    // ----------------- REPOSITORIES -----------------
    final authRepository = AuthRepositoryImpl(authLocalDataSource);
    registerSingleton<AuthRepository>(authRepository);

    final bukuRepository = BukuRepositoryImpl(
      remoteDataSource: bukuRemoteDataSource,
      localDataSource: bukuLocalDataSource,
    );
    registerSingleton<BukuRepository>(bukuRepository);

    final kiosRepository = KiosRepositoryImpl(kiosLocalDataSource);
    registerSingleton<KiosRepository>(kiosRepository);

    final forumRepository = ForumRepositoryImpl(forumLocalDataSource);
    registerSingleton<ForumRepository>(forumRepository);

    final tentangRepository = TentangRepositoryImpl(tentangLocalDataSource);
    registerSingleton<TentangRepository>(tentangRepository);

    // ----------------- USE CASES -----------------
    // Auth
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    registerSingleton<LoginUseCase>(loginUseCase);
    registerSingleton<RegisterUseCase>(registerUseCase);
    registerSingleton<LogoutUseCase>(logoutUseCase);
    registerSingleton<GetCurrentUserUseCase>(getCurrentUserUseCase);

    // Buku
    final getBukuListUseCase = GetBukuListUseCase(bukuRepository);
    final createBukuUseCase = CreateBukuUseCase(bukuRepository);
    final getKategoriRingkasUseCase = GetKategoriRingkasUseCase(bukuRepository);
    final getKategoriTematikUseCase = GetKategoriTematikUseCase(bukuRepository);
    final getBukuTemuanUseCase = GetBukuTemuanUseCase(bukuRepository);
    registerSingleton<GetBukuListUseCase>(getBukuListUseCase);
    registerSingleton<CreateBukuUseCase>(createBukuUseCase);
    registerSingleton<GetKategoriRingkasUseCase>(getKategoriRingkasUseCase);
    registerSingleton<GetKategoriTematikUseCase>(getKategoriTematikUseCase);
    registerSingleton<GetBukuTemuanUseCase>(getBukuTemuanUseCase);

    // Kios
    final getDaftarKiosUseCase = GetDaftarKiosUseCase(kiosRepository);
    final getBukuPopulerUseCase = GetBukuPopulerUseCase(kiosRepository);
    final getFasilitasPublikUseCase = GetFasilitasPublikUseCase(kiosRepository);
    registerSingleton<GetDaftarKiosUseCase>(getDaftarKiosUseCase);
    registerSingleton<GetBukuPopulerUseCase>(getBukuPopulerUseCase);
    registerSingleton<GetFasilitasPublikUseCase>(getFasilitasPublikUseCase);

    // Forum
    final getPostsUseCase = GetPostsUseCase(forumRepository);
    final createPostUseCase = CreatePostUseCase(forumRepository);
    final toggleLikeUseCase = ToggleLikeUseCase(forumRepository);
    registerSingleton<GetPostsUseCase>(getPostsUseCase);
    registerSingleton<CreatePostUseCase>(createPostUseCase);
    registerSingleton<ToggleLikeUseCase>(toggleLikeUseCase);

    // Tentang
    final getFaqUseCase = GetFaqUseCase(tentangRepository);
    final getFasilitasPengunjungUseCase = GetFasilitasPengunjungUseCase(tentangRepository);
    registerSingleton<GetFaqUseCase>(getFaqUseCase);
    registerSingleton<GetFasilitasPengunjungUseCase>(getFasilitasPengunjungUseCase);

    // ----------------- VIEW MODELS -----------------
    final authViewModel = AuthViewModel(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
    );
    registerSingleton<AuthViewModel>(authViewModel);

    final stokKategoriViewModel = StokKategoriViewModel(
      getBukuListUseCase: getBukuListUseCase,
    );
    registerSingleton<StokKategoriViewModel>(stokKategoriViewModel);

    final denahViewModel = DenahViewModel(
      getDaftarKiosUseCase: getDaftarKiosUseCase,
      getBukuPopulerUseCase: getBukuPopulerUseCase,
      getFasilitasPublikUseCase: getFasilitasPublikUseCase,
    );
    registerSingleton<DenahViewModel>(denahViewModel);

    final forumViewModel = ForumViewModel(
      getPostsUseCase: getPostsUseCase,
      createPostUseCase: createPostUseCase,
      toggleLikeUseCase: toggleLikeUseCase,
    );
    registerSingleton<ForumViewModel>(forumViewModel);

    // Dibuat baru tiap diminta: dimiliki dan di-dispose oleh halaman Tentang.
    registerFactory<TentangViewModel>(() => TentangViewModel(
          getFaqUseCase: getFaqUseCase,
          getFasilitasPengunjungUseCase: getFasilitasPengunjungUseCase,
        ));
  }
}
