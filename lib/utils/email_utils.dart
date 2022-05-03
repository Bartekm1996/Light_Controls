part of utils;

class EmailUtils{

  static void sendEmail(String exception, String stackTrace){
    final mailer = Mailer('');
    final toAddress = Address('');
    final fromAddress = Address('');
    final content = Content('text/plain', stackTrace);
    final subject = 'Lights Control - ' + exception;
    final personalization = Personalization([toAddress]);
    final email = Email([personalization], fromAddress, subject, content: [content]);

    mailer.send(email).then((result) {

    });
  }

}
