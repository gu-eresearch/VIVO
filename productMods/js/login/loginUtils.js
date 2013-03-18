/* $This file is distributed under the terms of the license in /doc/license.txt$ */

$(document).ready(function(){

    // login form is hidden by default; use JavaScript to reveal
    $("#login").removeClass('hidden');
  
    // focus on email or newpassword field
    $('.focus').focus();
    
    // fade in error alerts
    $('section#error-alert').css('display', 'none').fadeIn(1500); 
    
    $(document).ready(function(){
        //$('.admin-login').click(function(){
        //    $('#login-form-box').slideToggle(500);
        //    $(this).contents().replaceWith('Hide Admin Login');
        //    console.log('clicked');
        //    return false;
        // });
        $('.admin-login').click().toggle(function() {
          $('#login-form-box').fadeIn(500);
          $(this).contents().replaceWith('Hide Admin Login');
          $(this).toggleClass('close');
        }, function() {
          $('#login-form-box').fadeOut(500);
          $(this).contents().replaceWith('Show Admin Login');
          $(this).toggleClass('close');
        });
    }); 
});