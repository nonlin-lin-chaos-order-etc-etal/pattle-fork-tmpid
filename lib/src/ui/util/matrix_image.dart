// Copyright (C) 2019  Wilko Manger
//
// This file is part of Pattle.
//
// Pattle is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Pattle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Pattle.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:url/url.dart';

import 'matrix_cache_manager.dart';

class MatrixImage extends ImageProvider<MatrixImage> {

  /// Matrix URL pointing to the image.
  final Url url;

  final double scale;
  final int width, height;

  /// A Matrx image. If width and height are provided, downloads a thumbnail.
  const MatrixImage(this.url, {this.scale = 1.0, this.width, this.height});

  Future<Codec> _load(MatrixImage key) async {
    final file = await cacheManager.getSingleFile(key.url.toString(), headers: {
      'width': key.width.toString(),
      'height': key.height.toString()
    });

    if (file == null) {
      return null;
    }

    final bytes = Uint8List.fromList(await file.readAsBytes());

    return PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  ImageStreamCompleter load(MatrixImage key) {
    return MultiFrameImageStreamCompleter(
      codec: _load(key),
      scale: key.scale
    );
  }

  @override
  Future<MatrixImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MatrixImage>(this);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;

    final MatrixImage typedOther = other;
    return url == typedOther.url
      && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

}