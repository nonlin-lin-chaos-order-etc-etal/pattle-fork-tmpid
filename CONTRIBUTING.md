# Contributing

  Contributions are highly encouraged!

  To see what you can do, you can look at
  [open issues](https://git.pattle.im/pattle/pattle/issues),
  join [#app:pattle.im](https://matrix.to/#/#app:pattle.im),
  [contact me directly](https://matrix.to/#/@wilko:pattle.im)!

  When contributing code to Pattle, your code will be licensed under the
  [AGPLv3](https://www.gnu.org/licenses/agpl-3.0.en.html).

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

## Before you can contribute

   We use the [DCO](https://developercertificate.org/), which asserts that the
   contribution is yours, and you allow Pattle to use it.

   If you agree to what's stated in the DCO (also shown under), you can
   sign-off your commits:

   ```
   Signed-off-by: Joe Smith <joe.smith@email.org>
   ```

   If your `user.name` and `user.email` are set for git, you can
   sign-off your commits using:

   ```
   git commit -s
   ```

   Contributions can only be accepted if you agree to the DCO,
   indicated by the sign-off.
   
   See [CONTRIBUTING.md](CONTRIBUTING.md) for details on contributing.

### DCO

   ```text
   Developer Certificate of Origin
   Version 1.1

   Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
   660 York Street, Suite 102,
   San Francisco, CA 94110 USA

   Everyone is permitted to copy and distribute verbatim copies of this
   license document, but changing it is not allowed.

   Developer's Certificate of Origin 1.1

   By making a contribution to this project, I certify that:

   (a) The contribution was created in whole or in part by me and I
       have the right to submit it under the open source license
       indicated in the file; or

   (b) The contribution is based upon previous work that, to the best
       of my knowledge, is covered under an appropriate open source
       license and I have the right under that license to submit that
       work with modifications, whether created in whole or in part
       by me, under the same open source license (unless I am
       permitted to submit under a different license), as indicated
       in the file; or

   (c) The contribution was provided directly to me by some other
       person who certified (a), (b) or (c) and I have not modified
       it.

   (d) I understand and agree that this project and the contribution
       are public and that a record of the contribution (including all
       personal information I submit with it, including my sign-off) is
       maintained indefinitely and may be redistributed consistent with
       this project or the open source license(s) involved.
   ```