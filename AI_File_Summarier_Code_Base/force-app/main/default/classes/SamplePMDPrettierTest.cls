public class SamplePMDPrettierTest{

private static Integer  counter=0;
public static final String nameValue='Test';

public static void processAccounts(){
List<Account> accs=[SELECT Id,Name FROM Account];
for(Account a:accs){
List<Contact> cons=[SELECT Id,LastName FROM Contact WHERE AccountId=:a.Id];
for(Contact c:cons){
insert c;
}
}
if(accs!=null){System.debug(accs);}
counter++;counter++;counter++;counter++;counter++;
counter++;counter++;counter++;counter++;counter++;
counter++;counter++;counter++;counter++;counter++;
counter++;counter++;counter++;counter++;counter++;
counter++;counter++;counter++;counter++;counter++;
}
}
