<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd">
<?php
session_start();
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="auto" lang="auto" dir="ltr">
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lock/Unlock Users</title>
        <link rel="shortcut icon" href="images/default/favicon.ico" type="image/vnd.microsoft.icon">
        <link type="text/css" rel="stylesheet" href="css/default/custom.css">
   <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/livevalidation_standalone.compressed.js"></script>
        <meta name="peoplebase" value="ou=people,{{ pla['ldap']['basedn'] }}"/>
</head>
<body>
        <script language="javascript">
        <!--
   function dateclick(button, userid) {
      if (button.value == "Remove user expiration date") {
         removeDate(button, userid);
      } else {
         setDate(button, userid);
      }
   }

   function setDate(button, userid) {
      button.disabled = true;

      var dateVals = $('#date_' + userid.replace(".", "_")).val().split("/");
      if (dateVals.length != 3) {
         alert("Inserted date is not valid.");
      }
      else {
         dateVals = dateVals[2] + "" + dateVals[1] + "" + dateVals[0] + "000000Z";

         $.ajax({
            type: "POST",
            url: "action_lock.php",
            data: {
               userid: userid,
               dateval: dateVals,
               action: "setdate"
            },
            success: function(data, textStatus, jqXHR) {
               if (data["status"] == "ok") {
                  button.value = "Remove user expiration date";
               }
               else {
                  alert("An error occurred while setting the expiration date for the user " + userid + ":\n" + data["error"]);
               }
            },
            error: function(jqXHR, textStatus, errorThrown) {
               alert("An error occurred while setting the expiration date for the user " + userid + ":\n" + errorThrown);
            },
            dataType: "json"
         });
      }
      button.disabled = false;
   }

        function removeDate(button, userid) {
                button.disabled = true;

                $.ajax({
                        type: "POST",
                        url: "action_lock.php",
                        data: {
                                userid: userid,
                                action: "removedate"
                        },
                        success: function(data, textStatus, jqXHR) {
                                if (data["status"] == "ok") {
                                        button.value = "Set the user expiration date";
                                }
                                else {
                                        alert("An error occurred while locking the user " + userid + ":\n" + data["error"]);
                                }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                                alert("An error occurred while unlocking the user " + userid + ":\n" + errorThrown);
                        },
                        dataType: "json"
                });

            $('#date_' + userid.replace(".", "_")).val('');
                button.disabled = false;
        }

   function lockclick(button, userid) {
      if (button.value == "Unlock") {
         unlockUser(button, userid);
      }
      else {
         lockUser(button, userid);
      }
   }

   function lockUser(button, userid) {
      button.disabled = true;
   
      $.ajax({
         type: "POST",
         url: "action_lock.php",
         data: {
            userid: userid,
            action: "lock"
         },
         success: function(data, textStatus, jqXHR) {
            if (data["status"] == "ok") {
               button.value = "Unlock";
            }
            else {
               alert("An error occurred while locking the user " + userid + ":\n" + data["error"]);
            }
         },
         error: function(jqXHR, textStatus, errorThrown) {
            alert("An error occurred while locking the user " + userid + ":\n" + errorThrown);
         },
         dataType: "json"
      });
      
      $('#row_' + userid.replace(".", "_")).addClass('locked');
      button.disabled = false;
   }

        function unlockUser(button, userid) {
                button.disabled = true;

                $.ajax({
                        type: "POST",
                        url: "action_lock.php",
                        data: {
                                userid: userid,
                                action: "unlock"
                        },
                        success: function(data, textStatus, jqXHR) {
                                if (data["status"] == "ok") {
                                        button.value = "Lock";
                                }
                                else {
                                        alert("An error occurred while locking the user " + userid + ":\n" + data["error"]);
                                }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                                alert("An error occurred while unlocking the user " + userid + ":\n" + errorThrown);
                        },
                        dataType: "json"
                });

            $('#row_' + userid.replace(".", "_")).removeClass('locked');
                button.disabled = false;
        }
        // -->
        </script>

        <table class="page" border="0" width="100%">
        <tbody>
                <tr class="pagehead">
                        <td colspan="3"><div id="ajHEAD">
                                <table width="100%" border="0">
                                <tbody>
                                        <tr>
                                                <td align="left"><a href="lockuser.php" target="_self"><img src="images/default/logo-small.png" alt="Logo" class="logo"></a></td>
                                                <td class="imagetop">&nbsp;</td>
                                        </tr>
                                </tbody>
                                </table>
                        </div></td>
                </tr>
                <tr class="control">
                        <td colspan="3"><div id="ajCONTROL">
                                <table class="control" width="100%" border="0">
                                <tbody>
                                        <tr>
                                                <td><a href="lockuser.php" title="Start">Start</a></td>
                                        </tr>
                                </tbody>
                                </table>
                        </div></td>
                </tr>
                <tr>
                        <td class="tree"><div id="ajSID_1" style="display: block"><table class="tree" border="0"><tbody><tr class="server"><td class="icon"><img src="images/default/server.png" alt="Server"></td>
                        <td class="name">My LDAP Server</td>
                        </td></tr></table></td>
                        <td class="spacer"></td>
                        <td class="body" width="80%"><div id="ajBODY">
                                <table class="body">
                                <tbody>
                                        <tr>
                                                <td><center>
        <h3 class="title">Lock/Unlock of the users</h3>
        <h3 class="subtitle">
                Server: <b>My LDAP Server</b>&nbsp;&nbsp;&nbsp;Contenitore: <b>ou=people,{{ pla['ldap']['basedn'] }}</b></h3>
                <center><h4>Identity Provider: Locking/Unlocking Users</h4></center>

                <table class="entry" cellspacing="0" align="center" border="0">
                <tbody>
                        <tr>
                                <td class="title">User list</a></td>
                        </tr>
                        <tr><td>
                                <?php
                                $ds = ldap_connect("localhost", 389) or die("Could not connect to $ldaphost");
                                if ($ds) {
                                ?>
                                <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                <tbody>
                                        <?php
                                        ldap_set_option($ds, LDAP_OPT_PROTOCOL_VERSION, 3);
                                        $connuser = "{{ pla['ldap']['root_dn'] }}";
                                        $connpasswd = "{{ pla['ldap']['root_pw'] }}";
                                        $r = ldap_bind($ds, $connuser, $connpasswd);
                                        if(!$r) die("ldap_bind failed<br>");

                                        $users = array();
                                        $filter = "(objectClass=*)";
                                        $dn = "ou=people,{{ pla['ldap']['basedn'] }}";
               $ldap_result = ldap_search($ds, $dn, $filter, Array('uid', 'cn', 'pwdAccountLockedTime', 'schacExpiryDate'));
                                        $curusers = ldap_get_entries($ds, $ldap_result);

                                        foreach ($curusers as $user) {
                                                if ($user["cn"]["count"] == 1) {
                                                        $curuser['id'] = $user["uid"][0];
                                                        $curuser['name'] = $user["cn"][0];

                     if ($user["pwdaccountlockedtime"][0] != "") {
                        $curuser['locked'] = True;
                        $curuser['text1'] = "Unlock";
                     }
                     else {
                        $curuser['locked'] = False;
                        $curuser['text1'] = "Lock";
                     }

                     if ($user["schacexpirydate"][0] != "") {
                        $curuser['expiryDate'] = substr($user["schacexpirydate"][0], 6, 2) . "/" . substr($user["schacexpirydate"][0], 4, 2) . "/" . substr($user["schacexpirydate"][0], 0, 4);
                        $curuser['text2'] = "Remove user expiration date";
                     }
                     else {
                        $curuser['expiryDate'] = "";
                        $curuser['text2'] = "Set user expiration date";
                     }

                     $users[] = $curuser;
                  }
               }

                                        sort($users);

                                        foreach ($users as $user) {
                                                ?>
                  <script>
                  $(function() {
                     $("#date_<?= str_replace(".", "_", $user['id']) ?>").datepicker({dateFormat: "dd/mm/yy"});
                  });
                  </script>
                                                <tr id="row_<?= str_replace(".", "_", $user['id']) ?>" height="20" class="<?php if ($user['locked']) { ?>locked<?php } ?>">
                                                        <td class="icon" width="5"><img src="images/default/ldap-uid.png" alt="Icon" align="top">&nbsp;</td>
                                                        <td valign="top" width="250"><?= $user["name"] ?></td>
                                                        <td valign="top" width="250">User Expiration Date: <input id="date_<?= str_replace(".", "_", $user['id']) ?>" type="text" value="<?= $user["expiryDate"] ?>" style="width: 90px" /></td>
                                                        <td valign="top">
                        <input type="button" value="<?= $user["text2"] ?>" onclick="javascript:dateclick(this, '<?= $user["id"] ?>')" />
                        <input type="button" value="<?= $user["text1"] ?>" onclick="javascript:lockclick(this, '<?= $user["id"] ?>')" />
                     </td>
                                                        <td valign="top" width="5" align="right"></td>
                                                </tr>
                                                <?php
                                        }
                                        ?>
                                </tbody>
                                </table>
                                <?php
                                }
                                ?>
                        </td></tr>
                </tbody>
                </table>

                                                </center></td>
                                        </tr>
                                </tbody>
                                </table>
                        </div></td>
                </tr>
                <tr class="foot"><td><small>&nbsp;</small></td><td colspan="4"><div id="ajFOOT">1.2.0.5</div><a href="//sourceforge.net/projects/phpldapadmin"><img src="//sflogo.sourceforge.net/sflogo.php?group_id=61828&type=8" border="0" alt="SourceForge.net Logo"></a></td></tr>
        </tbody>
        </table>
</body>
</html>
