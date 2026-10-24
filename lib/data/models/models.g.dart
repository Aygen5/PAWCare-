part of 'models.dart';

// **************************************************************************
// TypeAdapter implementations for Hive
// **************************************************************************

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 0;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.owner;
      case 1:
        return UserRole.sitter;
      default:
        return UserRole.owner;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.owner:
        writer.writeByte(0);
        break;
      case UserRole.sitter:
        writer.writeByte(1);
        break;
    }
  }
}

class VaccineStatusAdapter extends TypeAdapter<VaccineStatus> {
  @override
  final int typeId = 1;

  @override
  VaccineStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VaccineStatus.completed;
      case 1:
        return VaccineStatus.upcoming;
      case 2:
        return VaccineStatus.overdue;
      default:
        return VaccineStatus.upcoming;
    }
  }

  @override
  void write(BinaryWriter writer, VaccineStatus obj) {
    switch (obj) {
      case VaccineStatus.completed:
        writer.writeByte(0);
        break;
      case VaccineStatus.upcoming:
        writer.writeByte(1);
        break;
      case VaccineStatus.overdue:
        writer.writeByte(2);
        break;
    }
  }
}

class VaccinationAdapter extends TypeAdapter<Vaccination> {
  @override
  final int typeId = 2;

  @override
  Vaccination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vaccination(
      id: fields[0] as String,
      title: fields[1] as String,
      dueDate: fields[2] as String,
      status: fields[3] as VaccineStatus,
      vetName: fields[4] as String,
      completionDate: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Vaccination obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.vetName)
      ..writeByte(5)
      ..write(obj.completionDate);
  }
}

class DogAdapter extends TypeAdapter<Dog> {
  @override
  final int typeId = 3;

  @override
  Dog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dog(
      id: fields[0] as String,
      name: fields[1] as String,
      breed: fields[2] as String,
      ageYears: fields[3] as int,
      weightKg: fields[4] as double,
      gender: fields[5] as String,
      microchip: fields[6] as String,
      photoPath: fields[7] as String,
      allergyNote: fields[8] as String,
      behaviorNote: fields[9] as String,
      clinicName: fields[10] as String,
      clinicPhone: fields[11] as String,
      vaccinations: (fields[12] as List).cast<Vaccination>(),
    );
  }

  @override
  void write(BinaryWriter writer, Dog obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.breed)
      ..writeByte(3)
      ..write(obj.ageYears)
      ..writeByte(4)
      ..write(obj.weightKg)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.microchip)
      ..writeByte(7)
      ..write(obj.photoPath)
      ..writeByte(8)
      ..write(obj.allergyNote)
      ..writeByte(9)
      ..write(obj.behaviorNote)
      ..writeByte(10)
      ..write(obj.clinicName)
      ..writeByte(11)
      ..write(obj.clinicPhone)
      ..writeByte(12)
      ..write(obj.vaccinations);
  }
}

class SitterListingAdapter extends TypeAdapter<SitterListing> {
  @override
  final int typeId = 4;

  @override
  SitterListing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SitterListing(
      id: fields[0] as String,
      name: fields[1] as String,
      facilityTitle: fields[2] as String,
      category: fields[3] as String,
      rating: fields[4] as double,
      reviewsCount: fields[5] as int,
      pricePerUnit: fields[6] as double,
      unitLabel: fields[7] as String,
      location: fields[8] as String,
      distanceKm: fields[9] as double,
      imagePath: fields[10] as String,
      galleryPaths: (fields[11] as List).cast<String>(),
      bio: fields[12] as String,
      amenities: (fields[13] as List).cast<String>(),
      isVerified: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SitterListing obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.facilityTitle)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.reviewsCount)
      ..writeByte(6)
      ..write(obj.pricePerUnit)
      ..writeByte(7)
      ..write(obj.unitLabel)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.distanceKm)
      ..writeByte(10)
      ..write(obj.imagePath)
      ..writeByte(11)
      ..write(obj.galleryPaths)
      ..writeByte(12)
      ..write(obj.bio)
      ..writeByte(13)
      ..write(obj.amenities)
      ..writeByte(14)
      ..write(obj.isVerified);
  }
}

class BookingStatusAdapter extends TypeAdapter<BookingStatus> {
  @override
  final int typeId = 5;

  @override
  BookingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookingStatus.pending;
      case 1:
        return BookingStatus.confirmed;
      case 2:
        return BookingStatus.rejected;
      case 3:
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, BookingStatus obj) {
    switch (obj) {
      case BookingStatus.pending:
        writer.writeByte(0);
        break;
      case BookingStatus.confirmed:
        writer.writeByte(1);
        break;
      case BookingStatus.rejected:
        writer.writeByte(2);
        break;
      case BookingStatus.completed:
        writer.writeByte(3);
        break;
    }
  }
}

class BookingRequestAdapter extends TypeAdapter<BookingRequest> {
  @override
  final int typeId = 6;

  @override
  BookingRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingRequest(
      id: fields[0] as String,
      sitterId: fields[1] as String,
      sitterName: fields[2] as String,
      sitterPhoto: fields[3] as String,
      petName: fields[4] as String,
      petBreed: fields[5] as String,
      serviceTitle: fields[6] as String,
      startDate: fields[7] as DateTime,
      endDate: fields[8] as DateTime,
      totalPrice: fields[9] as double,
      careNotes: fields[10] as String,
      status: fields[11] as BookingStatus,
    );
  }

  @override
  void write(BinaryWriter writer, BookingRequest obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sitterId)
      ..writeByte(2)
      ..write(obj.sitterName)
      ..writeByte(3)
      ..write(obj.sitterPhoto)
      ..writeByte(4)
      ..write(obj.petName)
      ..writeByte(5)
      ..write(obj.petBreed)
      ..writeByte(6)
      ..write(obj.serviceTitle)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.totalPrice)
      ..writeByte(10)
      ..write(obj.careNotes)
      ..writeByte(11)
      ..write(obj.status);
  }
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 7;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      id: fields[0] as String,
      senderName: fields[1] as String,
      text: fields[2] as String,
      time: fields[3] as String,
      isMe: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderName)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.isMe);
  }
}

class NotificationItemAdapter extends TypeAdapter<NotificationItem> {
  @override
  final int typeId = 8;

  @override
  NotificationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationItem(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      timestamp: fields[3] as DateTime,
      isRead: fields[4] as bool,
      type: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.type);
  }
}
