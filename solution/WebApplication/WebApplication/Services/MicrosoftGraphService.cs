﻿using Microsoft.Extensions.Options;
using Microsoft.Graph;
using Microsoft.Graph.Auth;
using Microsoft.Identity.Client;
using Microsoft.Identity.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApplication.Forms.PIAWizard;
using WebApplication.Models;
using WebApplication.Models.Options;
using System.Security.Claims;

namespace WebApplication.Services
{
    public class MicrosoftGraphService : IMicrosoftGraphService
    {
        private readonly IOptions<MicrosoftIdentityOptions> _azureOptions;
        private readonly IOptions<SecurityModelOptions> _securityOptions;
        private GraphServiceClient _graphServiceClient;

        public MicrosoftGraphService(IOptions<MicrosoftIdentityOptions> azureOptions, IOptions<SecurityModelOptions> securityOptions)
        {
            _azureOptions = azureOptions;
            _securityOptions = securityOptions;

            IConfidentialClientApplication confidentialClient = ConfidentialClientApplicationBuilder
                .Create(_azureOptions.Value.ClientId)
                .WithTenantId(_azureOptions.Value.TenantId)
                .WithClientSecret(_azureOptions.Value.ClientSecret)
                .Build();

            ClientCredentialProvider authProvider = new ClientCredentialProvider(confidentialClient);
            _graphServiceClient = new GraphServiceClient(authProvider);
        }

        public async Task<IEnumerable<UserReference>> GetMembers()
        {
            List<UserReference> users = new List<UserReference>();

            Dictionary<string, User> members = new Dictionary<string, User>();

            foreach (var secRole in _securityOptions.Value.SecurityRoles)
            {
                if (_securityOptions.Value.SecurityRoles.TryGetValue(secRole.Key, out var role) && !string.IsNullOrEmpty(role.SecurityGroupId))
                {
                    var memberData = await _graphServiceClient.Groups[$"{ role.SecurityGroupId }"].Members?
                        .Request()
                        .GetAsync();

                    foreach (var member in memberData)
                    {
                        if (!members.ContainsKey(member.Id))
                        {
                            members.Add(member.Id, (User)member);
                        }   
                    }
                }
                else
                {
                    Console.Out.WriteLine($"{ secRole.Key } security group missing from config");
                }
            }

            users = members
                .Select(u => new UserReference
                {
                    DisplayName = u.Value.DisplayName,
                    UserId = u.Value.Id
                })
                .ToList();

            return users;
        }

        public async Task<(string name, string email)> GetUserMailIdentity(string upn)
        {
            var userData = await _graphServiceClient.Users[$"{ upn }"].Request().GetAsync();

            if (userData == null)
                throw new Exception("User not found");

            return (userData.DisplayName, userData.Mail);
        }

    }
}