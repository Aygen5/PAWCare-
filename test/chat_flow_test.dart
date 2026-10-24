import 'package:flutter_test/flutter_test.dart';
import 'package:paw_care/core/utils/app_state.dart';
import 'package:paw_care/domain/entities/user_role.dart';

void main() {
  group('Rol Duyarlı Sohbet ve Bildirim Simülasyonu Testleri', () {
    test('Hizmet Veren (Ayşe) mesaj gönderdiğinde Köpek Sahibine (Aygen) bildirim düşer ve odalar ayrışır', () {
      final appState = AppState();

      // 1. Hizmet Veren moduna geç
      appState.setRole(UserRole.sitter);
      expect(appState.role, UserRole.sitter);

      // Başlangıçta sahip bildirim sayısı
      appState.setRole(UserRole.owner);
      final initialOwnerNotifCount = appState.notifications.length;
      appState.setRole(UserRole.sitter);

      // 2. Ayşe Yılmaz hesabından Aygen'e mesaj gönder
      appState.sendChatMessage(
        'Merhaba Aygen Hanım, Barley mamasını severek yedi!',
        participantName: 'Aygen (Köpek Sahibi)',
      );

      // Ayşe'nin odasındaki mesajları doğrula
      final ayseRoomMessages = appState.getChatMessagesFor('Ayşe Yılmaz');
      expect(ayseRoomMessages.any((m) => m.text.contains('Barley mamasını severek yedi')), isTrue);
      final lastMsg = ayseRoomMessages.last;
      expect(lastMsg.senderName, 'Ayşe Yılmaz');
      expect(lastMsg.senderRole, UserRole.sitter);

      // Mert Demir'in odasında bu mesaj OLMAMALI (odalar izole)
      final mertRoomMessages = appState.getChatMessagesFor('Mert Demir');
      expect(mertRoomMessages.any((m) => m.text.contains('Barley mamasını severek yedi')), isFalse);

      // 3. Köpek Sahibi (Aygen) moduna geç
      appState.setRole(UserRole.owner);

      // Aygen'in bildirimlerinde yeni mesaj bildirimi olmalı
      expect(appState.notifications.length, initialOwnerNotifCount + 1);
      expect(appState.notifications.first.title, contains("Ayşe Yılmaz'dan Yeni Mesaj"));
      expect(appState.notifications.first.body, contains('Barley mamasını severek yedi'));

      // Aygen Ayşe ile sohbeti açtığında mesajı görür
      final ownerViewMessages = appState.getChatMessagesFor('Ayşe Yılmaz');
      final msgInOwnerView = ownerViewMessages.last;
      // Aygen modundayken mesajın sahibi Aygen değildir (isMe = false)
      final isMeForOwner = msgInOwnerView.senderRole == appState.role;
      expect(isMeForOwner, isFalse);
    });

    test('Köpek Sahibi (Aygen) mesaj gönderdiğinde Hizmet Verene bildirim düşer', () {
      final appState = AppState();

      // Köpek Sahibi modunda Ayşe'ye mesaj yaz
      appState.setRole(UserRole.owner);
      appState.sendChatMessage(
        'Teşekkürler Ayşe Hanım, çok sevindim!',
        participantName: 'Ayşe Yılmaz',
      );

      // Hizmet Veren moduna geç
      appState.setRole(UserRole.sitter);
      expect(appState.notifications.first.title, contains("Aygen Yıldırım'dan Yeni Mesaj"));
      expect(appState.notifications.first.body, contains('Teşekkürler Ayşe Hanım'));
    });
  });
}
