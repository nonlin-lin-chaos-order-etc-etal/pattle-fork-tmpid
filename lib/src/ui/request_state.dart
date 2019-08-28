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

class RequestState {
  final int _value;

  const RequestState(int value) : _value = value;

  static const none = RequestState(0);
  static const active = RequestState(1);
  static const stillActive = RequestState(2);
  static const success = RequestSuccessState();

  @override
  bool operator ==(other) {
    if (other is RequestState) {
      return other._value == this._value;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _value.hashCode;
}

class RequestSuccessState<T> extends RequestState {
  final T data;

  const RequestSuccessState({this.data}) : super(3);
}
