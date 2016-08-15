//
//  Repository+Init.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation
import CLibgit2

// MARK: - Repository extension for openning
extension Repository {
    
    /// Constructor with URL and manager
    ///
    /// - parameter url:     Repository URL
    /// - parameter manager: Repository manager
    ///
    /// - throws: GitError
    ///
    /// - returns: Repository
    convenience init(openAt url: URL, manager: RepositoryManager) throws {
        
        // Repository pointer
        let repository = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        // Init repo
        let error = git_repository_open(repository, url.path)
        if (error != 0) {
            repository.deinitialize()
            repository.deallocate(capacity: 1)
            throw gitUnknownError("Unable to open repository, url: \(url)", code: error)
        }
        
        self.init(at: url, manager: manager, repository: repository)
    }
    
    /// Init new repository at URL
    ///
    /// - parameter url:       Repository URL
    /// - parameter manager:   Repository manager
    /// - parameter signature: Initial commiter
    /// - parameter bare:      Create bare repository
    ///
    /// - throws: GitError
    ///
    /// - returns: Repository
    convenience init(initAt url: URL, manager: RepositoryManager, signature: Signature, bare: Bool) throws {
        
        // Repository pointer
        let repository = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        // Init repo
        let error = git_repository_init(repository, url.path, bare ? 1 : 0)
        if (error != 0) {
            repository.deinitialize()
            repository.deallocate(capacity: 1)
            throw gitUnknownError("Unable to init repository, url: \(url) (bare \(bare))", code: error)
        }
        
        self.init(at: url, manager: manager, repository: repository)
    }
}
