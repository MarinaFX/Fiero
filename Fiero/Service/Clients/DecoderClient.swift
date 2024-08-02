//
//  DecoderClient.swift
//  Fiero
//
//  Created by Marina De Pazzi on 29/07/24.
//

import Foundation
import Combine

protocol DecoderClient: TopLevelDecoder where Input == Data { }

extension JSONDecoder: DecoderClient { }
