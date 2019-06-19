# Contributing

  Contributions are highly encouraged!

  To see what you can do, you can look at
  [open issues](https://git.pattle.im/pattle/pattle/issues),
  join [#app:pattle.im](https://matrix.to/#/#app:pattle.im),
  [contact me directly](https://matrix.to/#/@wilko:pattle.im)!

  When contributing code to Pattle, your code will be licensed under the
  [AGPLv3](https://www.gnu.org/licenses/agpl-3.0.en.html).

## CLA

  To contribute, a [CLA](https://git.pattle.im/pattle/util/cla/blob/master/cla.pdf)
  has to be signed. This is the Fiduciary Contributor License Agreement,
  a very free software friendly license agreement. It actually guarantees you (the Contributor)
  that your contributions will never be relicensed to anything other than AGPL version 3 or
  higher.

  To sign the CLA, please send a signed copy to [wilko@rens.onl](mailto:wilko@rens.onl).

  An image of your signature is also okay, to do this easily you can edit the
  [HTML version](https://git.pattle.im/pattle/util/cla/blob/master/cla.html), add a
  photo of your signature as an `<img>` tag, render it with
  [`pandoc`](https://pandoc.org/) using:
  ```sh
  pandoc cla-signed.html -t html -o cla-signed.pdf --css cla.css
  ```

  Please note that in the future the signing process will be automated using
  [CLAM](https://gitlab.com/Xatom/CLAM).

## General contribution steps

  1. Fork the project.
  2. Create a feature/bug branch named, for example: `logout`.
  3. Make your changes.
  4. Add copyright notices
      1. If you have **edited** an existing file, add your copyright notice
         under the existing ones last, in the format of:
         ```
         Copyright (C) YEAR  Full Name <email@example.com> (CLA signed)
         ```
         Note the double space between `YEAR` and `Full Name`.
      2. If you **created** a file, add the license file header with your name
         and email. (See [File headers](#file-headers))
  5. Commit your changes and
     [create a merge request](https://git.pattle.im/pattle/pattle/merge_requests/new).

  Note that if you're creating a new feature, you probably also need to implement
  it in the [Matrix Dart SDK](https://git.pattle.im/pattle/library/matrix-dart-sdk).

## File headers

  Every file has a license header with copyright notices. Every copyright
  notice is in the format of:
  ```
  Copyright (C) YEAR  Full Name <email@example.com> (CLA signed)
  ```
  Note the double space between the year and full name.

  The creator of the file is on top, and every contributor afterwards is
  listed below in chronological order. An example file header would be:

  ```
  // Copyright (C) 2018  Wilko Manger <wilko@rens.onl>
  // Copyright (C) 2018  Nathan van Beelen <nathan@vanbeelen.org> (CLA signed)
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
  ```

  Here, `Wilko Manger` is the file creator, and `Nathan van Beelen` contributed later on.
