import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms And Conditions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children:const [
          Text(
            'Vehicle owner/driver responsibilities and disclaimer',
            style: heading3Style,
          ),
          vSpace18,
          Text(
            '''1. Driver hereunder includes the owner, service provider or any person connected with the providing of service through this platform.
2. The term user shall also include every person using the platform for getting services of vehicles and beneficiary, agent, a proxy, or any person claiming through or under the user.
3. GiroKab does not determine, advise, have any control, or in any way involve
itself in the offering or acceptance between the user and driver.
4. GiroKab does not make any representations or warranties regarding the quality of service from drivers of the cabs. GiroKab does not implicitly or explicitly support or endorse any particular service agent on the Platform. GiroKab accepts no liability for any errors or omissions of third parties in relation to the services.
5. GiroKab is not responsible for any non-performance or breach of any contract between driver and user. GiroKab cannot and does not guarantee that driver or user concerned will perform transaction(s) concluded on the Platform. GiroKab shall not and is not required to mediate or resolve disputes or disagreements between driver and user.
6. GiroKab does not make any representations or warranties regarding the creditworthiness, identity, etc. of any of its users and drivers. You are advised to independently verify the bonafides of any particular service provider or client you choose to deal with on the Platform and use your best judgment in that regard.
7. GiroKab does not at any point in time during a transaction between driver and user on the Platform come into or take possession of any of the products or services offered between them, gain title to or have any rights or claims over the products or services offered by them.
8. At no time shall GiroKab hold any right/title to or interest in the items nor have any obligations or liabilities with respect to such a contract. GiroKab is not
responsible for the unsatisfactory or delayed performance of services.
9. The Platform is only a platform that can be utilized by driver/user to reach a larger customer base to provide and receive services. GiroKab only provides a platform for communication and it is agreed that the contract for the sale of any services shall be a strictly bipartite contract between user and driver.
10. The user and driver release and indemnify GiroKab and/or any of its officers and representatives from any cost, damage, liability or other consequence of any of the actions of the users on the Platform and specifically waive any claims that they may have in this behalf under any applicable law.
11. Notwithstanding its reasonable efforts in that behalf, GiroKab cannot control the information provided by other users which are made available on the
Platform. The concerned may find other user's information to be offensive,
harmful, inaccurate or deceptive. Please use caution and practise safe trading when using the Platform. Please note that there may be risks in dealing with underage persons or people acting under false pretence.
12. You agree and understand that GiroKab and the Platform merely provide hosting services to its registered users and persons browsing/visiting the Platform. All items advertised/listed and the contents therein are advertised and listed by registered users and are third party user generated contents. GiroKab shall bear no responsibility or liability in relation to or arising out of content. GiroKab neither originates nor initiates the transmission nor selects the sender
and receiver of the transmission nor selects nor modifies the information contained in the transmission. GiroKab is merely an intermediary and does not interfere in the transaction between users and service providers.
13. Drivers are required to collect only the charges as published in the App if payment is made on the basis of on-site payments. Drivers are personally liable and responsible for the complaint on the excess collection of charges.
14. Drivers are duty-bound to deal with the users in a very decent and polite manner over and above the code of conduct applicable to the drivers holding badges as per law and shall not respond or behave in any unpleasant manner to the users.
15. Drivers alone shall be responsible for their dealings with the users in all aspects and no liability thereon passes to GiroKab under any circumstances.
16. It is the understanding that the drivers using the vehicle are holding valid driving licenses and the vehicle is insured with third-party risks. GiroKab is not liable for any tortious or other liabilities to the user or third-party.
17. The drivers and users are liable to abide by all rules of law and are individually and personally liable for the violations.''',
            style: bodyStyle,
          )
        ],
      ),
    );
  }
}
