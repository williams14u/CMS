﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CRM.UI.ViewModels;
using CRM.Business;
using CRM.Model;
namespace CRM.UI.Controllers
{
    public class ProductController : Controller
    {
        // GET: Product

        public ActionResult List()
        {
            List<ProductListVM> lst = new List<ProductListVM>();
            try
            {

                ProductBiz productBiz = new ProductBiz();
                List<Product> lstProducts = productBiz.GetProducts(1, 20, "");
                for (int i = 0; i < lstProducts.Count; i++)
                {
                    ProductListVM t = new ProductListVM();
                    t.ProductId = lstProducts[i].Id.ToString();
                    t.ProductName = lstProducts[i].Name;
                    t.CompanyName = lstProducts[i].CompanyName;
                    t.Version = lstProducts[i].Versions;
                    t.VersionId = lstProducts[i].VersionId;

                    lst.Add(t);
                }


                return View(lst);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("SM", ex.Message);
                return View(lst);
            }
        }

        public ActionResult Edit(int id)
        {
            try
            {
                ProductEditVM m = new ProductEditVM();
                ProductBiz productBiz = new ProductBiz();
                Product p = productBiz.GetProductInfo(id);
                m.ProductName = p.Name; // should get from databse;
                m.Version = p.Versions; // get from databse;
                m.OldVersion = p.Versions;


                return View(m);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost]
        public ActionResult Edit(ProductEditVM u, long id)
        {
            try
            {
                
               

                ProductBiz productBiz = new ProductBiz();
                u.ProductId = id;
                
                productBiz.UpdateProduct(u.ProductId, u.OldVersion, u.Version);

                ModelState.AddModelError("SM", "Product saved successfully");
                return View(u);
            }
            catch (Exception Ex)
            {
                ModelState.AddModelError("SM", Ex.Message);
                return View(u);
            }
        }
        
        
        public ActionResult Delete(long Id)
        {
            try
            {
                
                 ProductBiz productBiz = new ProductBiz();
                
                productBiz.DeleteProduct(Id);

                
               
            }
            catch (Exception Ex)
            {
                ModelState.AddModelError("DM", Ex.Message);
                
            }
            return RedirectToAction("List");
        }
        //Get user
        public ActionResult Create()
        {
            CreateNewProductVM m = new CreateNewProductVM();           
            ProductBiz productBiz = new ProductBiz();
            Product p = new Product();
            m.ProductName = p.Name; 
            m.Version = p.Versions; 
           m.Compaines = productBiz.GetCompanies();
            


            return View(m);
           
        }
        [HttpPost]
        public ActionResult Create(CreateNewProductVM np)
        {
            try
            {
                ///creating product
                ProductBiz productBiz = new ProductBiz();
                List<Company> lst = new List<Company>();
                Product product = new Product();
                product.Name = np.ProductName;
                product.Versions = np.Version;
                product.CompanyId = np.CompanyId;
                productBiz.CreateProduct(product);
                np.Compaines= productBiz.GetCompanies();
                ModelState.AddModelError("PM", "Product created successfully");
                return View(np);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            
        }
    }
}