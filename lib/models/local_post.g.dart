// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalPostAdapter extends TypeAdapter<LocalPost> {
  @override
  final int typeId = 1;

  @override
  LocalPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalPost(
      postId: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      userId: fields[3] as String,
      authorName: fields[4] as String,
      authorProfileUrl: fields[5] as String,
      imageUrl: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      likes: fields[8] as int,
      commentCount: fields[9] as int,
      views: fields[10] as int,
      tags: (fields[11] as List).cast<String>(),
      isPinned: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LocalPost obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.authorName)
      ..writeByte(5)
      ..write(obj.authorProfileUrl)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.likes)
      ..writeByte(9)
      ..write(obj.commentCount)
      ..writeByte(10)
      ..write(obj.views)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.isPinned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
