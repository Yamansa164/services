import 'package:advanced_flutter_arabic/data/network/error_handler.dart';
import 'package:advanced_flutter_arabic/data/response/responses.dart';

const String STORE_DETAILS_KEY = "STORE_DETAILS_KEY";
const String HOME_KEY = "HOME_KEY";
const int HOME_INTERVAl = 60 * 1000;
const int STORE_DETAILS_INTERVAl = 60 * 1000;

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  Future<StoresDetailsResponse> getStoreDetailsData();
  Future<void> saveStoreDetailsToCache(StoresDetailsResponse storesDetailsResponse);
  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceimpl implements LocalDataSource {
  Map<String, CachedItem> cacheMap = Map();

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cachedItem = cacheMap[HOME_KEY];
    if (cachedItem != null && cachedItem.isValid(HOME_INTERVAl)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<void> saveStoreDetailsToCache(StoresDetailsResponse storesDetailsResponse)async {
    cacheMap[STORE_DETAILS_KEY] = CachedItem(storesDetailsResponse);
  }

  @override
  Future<StoresDetailsResponse> getStoreDetailsData() async {
    CachedItem ?cachedItem=cacheMap[STORE_DETAILS_KEY];
    if(cachedItem!=null && cachedItem.isValid(STORE_DETAILS_INTERVAl))
    {
      return cachedItem.data;

    }
    else {
      throw ErrorHandler.handle(cachedItem);
    }
  }
}

class CachedItem {
  dynamic data;
  int cachtime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtision on CachedItem {
  bool isValid(int expeirationTimeInMillis) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool isValid1 = currentTime - cachtime <= expeirationTimeInMillis;
    print(isValid1);
    return isValid1;
  }
}
