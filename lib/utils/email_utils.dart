part of utils;

class EmailUtils{

  static void sendEmail(String exception, String stackTrace){
    final mailer = Mailer('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');
    final toAddress = Address('bmlynarkiewicz1996@gmail.com');
    final fromAddress = Address('lightscontrol2021@gmail.com');
    final content = Content('text/plain', stackTrace);
    final subject = 'Lights Control - ' + exception;
    final personalization = Personalization([toAddress]);
    final email = Email([personalization], fromAddress, subject, content: [content]);

    mailer.send(email).then((result) {

    });
  }

}