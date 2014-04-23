﻿// -----------------------------------------------------------------------
// <copyright file="ContactsController.cs" company="Nodine Legal, LLC">
// Licensed to Nodine Legal, LLC under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Nodine Legal, LLC licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
// </copyright>
// -----------------------------------------------------------------------

namespace OpenLawOffice.WebClient.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Web.Mvc;
    using AutoMapper;

    [HandleError(View = "Errors/", Order = 10)]
    public class ContactsController : BaseController
    {
        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.List)]
        public ActionResult Index()
        {
            return View(GetList());
        }

        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.List)]
        public ActionResult ListJqGrid()
        {
            ViewModels.JqGridObject jqObject;
            List<ViewModels.Contacts.ContactViewModel> modelList = null;
            List<object> anonList = new List<object>();

            modelList = GetList();

            modelList.ForEach(x =>
            {
                anonList.Add(new
                {
                    Id = x.Id,
                    DisplayName = x.DisplayName,
                    City = x.Address1AddressCity,
                    State = x.Address1AddressStateOrProvince
                });
            });

            jqObject = new ViewModels.JqGridObject()
            {
                TotalPages = 1,
                CurrentPage = 1,
                TotalRecords = modelList.Count,
                Rows = anonList.ToArray()
            };

            return Json(jqObject, JsonRequestBehavior.AllowGet);
        }

        private List<ViewModels.Contacts.ContactViewModel> GetList()
        {
            List<ViewModels.Contacts.ContactViewModel> modelList = null;

            modelList = new List<ViewModels.Contacts.ContactViewModel>();

            OpenLawOffice.Data.Contacts.Contact.List().ForEach(x =>
            {
                modelList.Add(Mapper.Map<ViewModels.Contacts.ContactViewModel>(x));
            });

            return modelList;
        }

        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.Read)]
        public ActionResult Details(int id)
        {
            Common.Models.Contacts.Contact contact = null;
            ViewModels.Contacts.ContactViewModel viewModel;

            contact = OpenLawOffice.Data.Contacts.Contact.Get(id);

            if (contact == null)
                return View("InvalidRequest");

            viewModel = Mapper.Map<ViewModels.Contacts.ContactViewModel>(contact);
            PopulateCoreDetails(viewModel);

            return View(viewModel);
        }

        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.Create)]
        public ActionResult Create()
        {
            return View();
        }

        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.Create)]
        [HttpPost]
        public ActionResult Create(ViewModels.Contacts.ContactViewModel viewModel)
        {
            Common.Models.Security.User currentUser = null;
            Common.Models.Contacts.Contact model;

            currentUser = UserCache.Instance.Lookup(Request);

            model = Mapper.Map<Common.Models.Contacts.Contact>(viewModel);

            model = OpenLawOffice.Data.Contacts.Contact.Create(model, currentUser);

            return RedirectToAction("Index");
        }

        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.Modify)]
        public ActionResult Edit(int id)
        {
            Common.Models.Contacts.Contact model = null;
            ViewModels.Contacts.ContactViewModel viewModel;

            model = OpenLawOffice.Data.Contacts.Contact.Get(id);

            viewModel = Mapper.Map<ViewModels.Contacts.ContactViewModel>(model);

            return View(viewModel);
        }

        //
        // POST: /Contacts/Edit/5
        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.Modify)]
        [HttpPost]
        public ActionResult Edit(int id, ViewModels.Contacts.ContactViewModel viewModel)
        {
            Common.Models.Security.User currentUser = null;
            Common.Models.Contacts.Contact model;

            currentUser = UserCache.Instance.Lookup(Request);

            model = Mapper.Map<Common.Models.Contacts.Contact>(viewModel);

            model = OpenLawOffice.Data.Contacts.Contact.Edit(model, currentUser);

            return RedirectToAction("Index");
        }

        [SecurityFilter(SecurityAreaName = "Contacts", IsSecuredResource = false,
            Permission = Common.Models.PermissionType.Read)]
        public ActionResult Conflicts(int id)
        {
            List<Common.Models.Matters.Matter> matterList = null;
            Common.Models.Contacts.Contact contact;
            List<Tuple<Common.Models.Matters.Matter, Common.Models.Matters.MatterContact, Common.Models.Contacts.Contact>> matterRelationshipList;
            ViewModels.Contacts.ConflictViewModel viewModel = new ViewModels.Contacts.ConflictViewModel();

            contact = Data.Contacts.Contact.Get(id);

            viewModel.Contact = Mapper.Map<ViewModels.Contacts.ContactViewModel>(contact);

            viewModel.Matters = new List<ViewModels.Contacts.ConflictViewModel.MatterRelationship>();

            matterList = Data.Contacts.Contact.ListMattersForContact(id);

            foreach (var x in matterList)
            {
                ViewModels.Contacts.ConflictViewModel.MatterRelationship mr = new ViewModels.Contacts.ConflictViewModel.MatterRelationship();

                mr.Matter = Mapper.Map<ViewModels.Matters.MatterViewModel>(x);

                mr.MatterContacts = new List<ViewModels.Matters.MatterContactViewModel>();

                matterRelationshipList = Data.Contacts.Contact.ListMatterRelationshipsForContact(id, x.Id.Value);

                matterRelationshipList.ForEach(y =>
                {
                    ViewModels.Matters.MatterContactViewModel mc = Mapper.Map<ViewModels.Matters.MatterContactViewModel>(y.Item2);
                    mc.Contact = Mapper.Map<ViewModels.Contacts.ContactViewModel>(y.Item3);
                    mc.Matter = mr.Matter;
                    mr.MatterContacts.Add(mc);
                });

                viewModel.Matters.Add(mr);
            };

            return View(viewModel);
        }
    }
}