import Foundation

final class CacheManager {
    static let shared = CacheManager()
    
    private let cacheDirectory: URL
    private let maxCacheCount = 10
    
    private init() {
        cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        print("キャッシュのPath: \(cacheDirectory.description)")
    }
    
    // ファイル名生成
    private func getCacheFileName(for key: String) -> String {
        return "\(key).cache"
    }
    
    // 保存
    private func saveUserData(_ data: UserData) {
        guard let key = data.id else { return }
        let url = cacheDirectory.appendingPathComponent(getCacheFileName(for: key))
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: url)
            updateCache(data)
        } catch {
            print("キャッシュの保存に失敗: \(error)")
        }
    }
    
    // ユーザーデータ取得
    private func loadUserData(url: URL) -> UserData? {
        if FileManager.default.fileExists(atPath: url.path), !url.hasDirectoryPath {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(UserData.self, from: data)
            } catch {
                print("キャッシュの取得に失敗: \(error)")
                return nil
            }
        }
        return nil
    }
    
    // ユーザーデータのリストを取得
    func loadUserDataList() -> [UserData] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            let sortedUrls = urls.sorted { $0.lastPathComponent > $1.lastPathComponent }
            let dataList = sortedUrls.compactMap { loadUserData(url: $0) }
            return dataList
        } catch {
            print("キャッシュ取得失敗: \(error)")
            return []
        }
    }
    
    private func removeOldestCache() {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            if urls.count > maxCacheCount {
                let sortedFiles = urls.sorted { $0.lastPathComponent < $1.lastPathComponent }
                try FileManager.default.removeItem(at: sortedFiles.first!)
            }
        } catch {
            print("古いキャッシュの削除に失敗: \(error)")
        }
    }
    
    // ユーザーデータのキャッシュを更新
    private func updateCache(_ data: UserData) {
        guard let key = data.id else { return }
        let url = cacheDirectory.appendingPathComponent(getCacheFileName(for: key))
        let now = Date()
        do {
            try FileManager.default.setAttributes([.modificationDate: now], ofItemAtPath: url.path)
        } catch {
            print("キャッシュの更新に失敗: \(error)")
        }
    }
    
    // ユーザーデータを保存し、古いキャッシュを削除
    func cacheUserDate(_ data: UserData) {
        saveUserData(data)
        removeOldestCache()
    }
}
