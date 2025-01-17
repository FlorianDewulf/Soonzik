﻿using System;
using System.Diagnostics;
using Windows.ApplicationModel.Activation;
using Windows.Security.Authentication.Web;
using Facebook;

namespace SoonZik.Helpers
{
    public class FaceBookHelper
    {
        private const string FacebookAppId = "383777021829578"; //Enter your FaceBook App ID here  
        private const string FacebookPermissions = "user_about_me,read_stream,publish_actions";
        private readonly Uri _callbackUri = WebAuthenticationBroker.GetCurrentApplicationCallbackUri();
        private readonly FacebookClient _fb = new FacebookClient();
        private readonly Uri _loginUrl;

        public FaceBookHelper()
        {
            _loginUrl = _fb.GetLoginUrl(new
            {
                client_id = FacebookAppId,
                redirect_uri = _callbackUri.AbsoluteUri,
                scope = FacebookPermissions,
                display = "popup",
                response_type = "token"
            });
            Debug.WriteLine(_callbackUri); //This is useful for fill Windows Store ID in Facebook WebSite  
        }

        public string AccessToken
        {
            get { return _fb.AccessToken; }
        }

        private void ValidateAndProccessResult(WebAuthenticationResult result)
        {
            if (result.ResponseStatus == WebAuthenticationStatus.Success)
            {
                var responseUri = new Uri(result.ResponseData);
                var facebookOAuthResult = _fb.ParseOAuthCallbackUrl(responseUri);

                if (string.IsNullOrWhiteSpace(facebookOAuthResult.Error))
                    _fb.AccessToken = facebookOAuthResult.AccessToken;
            }
            else if (result.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
            {
// error de http  
            }
            else
            {
                _fb.AccessToken = null; //Keep null when user signout from facebook  
            }
        }

        public void LoginAndContinue()
        {
            WebAuthenticationBroker.AuthenticateAndContinue(_loginUrl);
        }

        public void ContinueAuthentication(WebAuthenticationBrokerContinuationEventArgs args)
        {
            ValidateAndProccessResult(args.WebAuthenticationResult);
        }
    }
}