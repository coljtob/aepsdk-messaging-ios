/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation

extension Dictionary where Key == String, Value == Any {
    /// Merges the values of `rhs` into `self`, preferring values in `rhs` when there is conflict.
    /// - Parameter rhs: a `[String: Any]` that will have its values merged into `self`.
    mutating func mergeXdm(rhs: [String: Any]) {
        self.merge(rhs) {
            _, new in new
        }
    }
}
