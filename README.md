# SecureMeApp

Sources:
    All sourcese included above code blocks.
    Used aws template for setting up integration with iot core.

Note:   
    When testing, cameras and alarms will not appear to work.
    These will be runninng under a different certificate for privacy reasoons.
    However, tthe video shows these features in actiton.
    Messaging will still work since it uses mqtt protocol and is facilitated by aws IoTCore using separate testing certificate.

Steps:
    1) Open xworkspace file.
    2) Make sure simulator target is iPhone 13 Pro
    3) Make sure build target is IoTSampleSwift
    4) Log in/sign up with firebase
    5) Connect using aws IoTCore
    6) Can view alarm status, event feed, and device controls.
    7) Can view camereas on separate tab.
    8) Can test out messaging by runing to separate simulators to see live updates.
    9) Can view what email user used to log in with and sign out on profile page (brings you back to sign in page)
