<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@ page import="org.opensrp.core.entity.User" %>
<%
    boolean PERM_WRITE_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY");
    boolean PERM_UPLOAD_FACILITY_CSV = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV");
    boolean PERM_UPLOAD_HEALTH_ID = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_HEALTH_ID");

    boolean PERM_READ_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY_LIST");

    boolean PERM_READ_HOUSEHOLD_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD");
    boolean PERM_READ_MOTHER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER");
    boolean PERM_READ_CHILD_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD");
    boolean PERM_READ_MEMBER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER");
    boolean PERM_READ_SIMILAR_EVENT_CLIENT = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT");
    boolean PERM_READ_SIMILARITY_DEFINITION = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION");

    boolean CHILD_GROWTH_REPORT = AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT");
    boolean CHILD_GROWTH_SUMMARY_REPORT = AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT");
    boolean ANALYTICS = AuthenticationManagerUtil.isPermitted("ANALYTICS");
    boolean PERM_READ_USER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST");
    boolean PERM_READ_ROLE_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_ROLE_LIST");
    boolean PERM_READ_LOCATION_TAG_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST");
    boolean PERM_READ_LOCATION_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST");
    boolean PERM_UPLOAD_LOCATION = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION");
    boolean PERM_READ_TEAM_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST");
    boolean PERM_READ_TEAM_MEMBER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST");
    boolean PERM_READ_EXPORT_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_EXPORT_LIST");
    boolean PERM_EXPORT_LIST = AuthenticationManagerUtil.isPermitted("PERM_EXPORT_LIST");
    boolean PERM_DOWNLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_DOWNLOAD_FORM");
    boolean PERM_UPLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FORM");
    boolean PERM_READ_AGGREGATED_REPORT = AuthenticationManagerUtil.isPermitted("PERM_READ_AGGREGATED_REPORT");
    boolean MEMBER_APPROVAL = AuthenticationManagerUtil.isPermitted("MEMBER_APPROVAL");
    boolean PERM_READ_BRANCH_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_BRANCH_LIST");
    User user = (User) AuthenticationManagerUtil.getLoggedInUser();
%>
    <div class="app-header__logo">
        <div class="logo-src"></div>
        <div class="header__pane ml-auto">
            <div>
                <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                        <span class="hamburger-box">
                            <span class="hamburger-inner"></span>
                        </span>
                </button>
            </div>
        </div>
    </div>
    <div class="app-header__mobile-menu">
        <div>
            <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                <span class="hamburger-box">
                    <span class="hamburger-inner"></span>
                </span>
            </button>
        </div>
    </div>
    <div class="app-header__menu">
        <span>
            <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                <span class="btn-icon-wrapper">
                    <i class="fa fa-ellipsis-v fa-w-6"></i>
                </span>
            </button>
        </span>
    </div>
    <div class="app-header__content">
        <div class="app-header-left">
            <div class="search-wrapper">
                <div class="input-holder">
                    <input type="text" class="search-input" placeholder="Type to search">
                    <button class="search-icon"><span></span></button>
                </div>
                <button class="close"></button>
            </div>
            <ul class="header-menu nav">
                <li class="nav-item">
                    <a href="javascript:void(0);" class="nav-link">
                        <i class="nav-link-icon fa fa-database"> </i>
                        Statistics
                    </a>
                </li>
                <li class="btn-group nav-item">
                    <a href="javascript:void(0);" class="nav-link">
                        <i class="nav-link-icon fa fa-edit"></i>
                        Projects
                    </a>
                </li>
                <li class="dropdown nav-item">
                    <a href="javascript:void(0);" class="nav-link">
                        <i class="nav-link-icon fa fa-cog"></i>
                        Settings
                    </a>
                </li>
            </ul>
        </div>

        <div class="app-header-right">
            <div class="header-btn-lg pr-0">
                <div class="widget-content p-0">
                    <div class="widget-content-wrapper">
                        <div class="widget-content-left">
                            <div class="btn-group">
                                <a data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="p-0 btn">
                                    <img width="42" class="rounded-circle" src="assets/images/avatars/1.jpg" alt="">
                                    <i class="fa fa-angle-down ml-2 opacity-8"></i>
                                </a>
                                <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right">
                                    <button type="button" tabindex="0" class="dropdown-item">User Account</button>
                                    <button type="button" tabindex="0" class="dropdown-item">Settings</button>
                                    <h6 tabindex="-1" class="dropdown-header">Header</h6>
                                    <button type="button" tabindex="0" class="dropdown-item">Actions</button>
                                    <div tabindex="-1" class="dropdown-divider"></div>
                                    <button type="button" tabindex="0" class="dropdown-item">Dividers</button>
                                </div>
                            </div>
                        </div>
                        <div class="widget-content-left  ml-3 header-user-info">
                            <div class="widget-heading">
                                Alina Mclourd
                            </div>
                            <div class="widget-subheading">
                                VP People Manager
                            </div>
                        </div>
                        <div class="widget-content-right header-user-info ml-3">
                            <button type="button" class="btn-shadow p-1 btn btn-primary btn-sm show-toastr-example">
                                <i class="fa text-white fa-calendar pr-1 pl-1"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="ui-theme-settings">
<%--    <button type="button" id="TooltipDemo" class="btn-open-options btn btn-warning">--%>
<%--        <i class="fa fa-cog fa-w-16 fa-spin fa-2x"></i>--%>
<%--    </button>--%>
    <div class="theme-settings__inner">
        <div class="scrollbar-container">
            <div class="theme-settings__options-wrapper">
                <h3 class="themeoptions-heading">Layout Options</h3>
                <div class="p-3">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <div class="widget-content p-0">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left mr-3">
                                        <div class="switch has-switch switch-container-class" data-class="fixed-header">
                                            <div class="switch-animate switch-on">
                                                <input type="checkbox" checked data-toggle="toggle" data-onstyle="success">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Fixed Header
                                        </div>
                                        <div class="widget-subheading">Makes the header top fixed, always visible!
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li class="list-group-item">
                            <div class="widget-content p-0">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left mr-3">
                                        <div class="switch has-switch switch-container-class" data-class="fixed-sidebar">
                                            <div class="switch-animate switch-on">
                                                <input type="checkbox" checked data-toggle="toggle" data-onstyle="success">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Fixed Sidebar
                                        </div>
                                        <div class="widget-subheading">Makes the sidebar left fixed, always visible!
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li class="list-group-item">
                            <div class="widget-content p-0">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left mr-3">
                                        <div class="switch has-switch switch-container-class" data-class="fixed-footer">
                                            <div class="switch-animate switch-off">
                                                <input type="checkbox" data-toggle="toggle" data-onstyle="success">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Fixed Footer</div>
                                        <div class="widget-subheading">Makes the app footer bottom fixed, always visible!</div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <h3 class="themeoptions-heading">
                    <div>
                        Header Options
                    </div>
                    <button type="button" class="btn-pill btn-shadow btn-wide ml-auto btn btn-focus btn-sm switch-header-cs-class" data-class="">
                        Restore Default
                    </button>
                </h3>
                <div class="p-3">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <h5 class="pb-2">Choose Color Scheme
                            </h5>
                            <div class="theme-settings-swatches">
                                <div class="swatch-holder bg-primary switch-header-cs-class" data-class="bg-primary header-text-light">
                                </div>
                                <div class="swatch-holder bg-secondary switch-header-cs-class" data-class="bg-secondary header-text-light">
                                </div>
                                <div class="swatch-holder bg-success switch-header-cs-class" data-class="bg-success header-text-dark">
                                </div>
                                <div class="swatch-holder bg-info switch-header-cs-class" data-class="bg-info header-text-dark">
                                </div>
                                <div class="swatch-holder bg-warning switch-header-cs-class" data-class="bg-warning header-text-dark">
                                </div>
                                <div class="swatch-holder bg-danger switch-header-cs-class" data-class="bg-danger header-text-light">
                                </div>
                                <div class="swatch-holder bg-light switch-header-cs-class" data-class="bg-light header-text-dark">
                                </div>
                                <div class="swatch-holder bg-dark switch-header-cs-class" data-class="bg-dark header-text-light">
                                </div>
                                <div class="swatch-holder bg-focus switch-header-cs-class" data-class="bg-focus header-text-light">
                                </div>
                                <div class="swatch-holder bg-alternate switch-header-cs-class" data-class="bg-alternate header-text-light">
                                </div>
                                <div class="divider">
                                </div>
                                <div class="swatch-holder bg-vicious-stance switch-header-cs-class" data-class="bg-vicious-stance header-text-light">
                                </div>
                                <div class="swatch-holder bg-midnight-bloom switch-header-cs-class" data-class="bg-midnight-bloom header-text-light">
                                </div>
                                <div class="swatch-holder bg-night-sky switch-header-cs-class" data-class="bg-night-sky header-text-light">
                                </div>
                                <div class="swatch-holder bg-slick-carbon switch-header-cs-class" data-class="bg-slick-carbon header-text-light">
                                </div>
                                <div class="swatch-holder bg-asteroid switch-header-cs-class" data-class="bg-asteroid header-text-light">
                                </div>
                                <div class="swatch-holder bg-royal switch-header-cs-class" data-class="bg-royal header-text-light">
                                </div>
                                <div class="swatch-holder bg-warm-flame switch-header-cs-class" data-class="bg-warm-flame header-text-dark">
                                </div>
                                <div class="swatch-holder bg-night-fade switch-header-cs-class" data-class="bg-night-fade header-text-dark">
                                </div>
                                <div class="swatch-holder bg-sunny-morning switch-header-cs-class" data-class="bg-sunny-morning header-text-dark">
                                </div>
                                <div class="swatch-holder bg-tempting-azure switch-header-cs-class" data-class="bg-tempting-azure header-text-dark">
                                </div>
                                <div class="swatch-holder bg-amy-crisp switch-header-cs-class" data-class="bg-amy-crisp header-text-dark">
                                </div>
                                <div class="swatch-holder bg-heavy-rain switch-header-cs-class" data-class="bg-heavy-rain header-text-dark">
                                </div>
                                <div class="swatch-holder bg-mean-fruit switch-header-cs-class" data-class="bg-mean-fruit header-text-dark">
                                </div>
                                <div class="swatch-holder bg-malibu-beach switch-header-cs-class" data-class="bg-malibu-beach header-text-light">
                                </div>
                                <div class="swatch-holder bg-deep-blue switch-header-cs-class" data-class="bg-deep-blue header-text-dark">
                                </div>
                                <div class="swatch-holder bg-ripe-malin switch-header-cs-class" data-class="bg-ripe-malin header-text-light">
                                </div>
                                <div class="swatch-holder bg-arielle-smile switch-header-cs-class" data-class="bg-arielle-smile header-text-light">
                                </div>
                                <div class="swatch-holder bg-plum-plate switch-header-cs-class" data-class="bg-plum-plate header-text-light">
                                </div>
                                <div class="swatch-holder bg-happy-fisher switch-header-cs-class" data-class="bg-happy-fisher header-text-dark">
                                </div>
                                <div class="swatch-holder bg-happy-itmeo switch-header-cs-class" data-class="bg-happy-itmeo header-text-light">
                                </div>
                                <div class="swatch-holder bg-mixed-hopes switch-header-cs-class" data-class="bg-mixed-hopes header-text-light">
                                </div>
                                <div class="swatch-holder bg-strong-bliss switch-header-cs-class" data-class="bg-strong-bliss header-text-light">
                                </div>
                                <div class="swatch-holder bg-grow-early switch-header-cs-class" data-class="bg-grow-early header-text-light">
                                </div>
                                <div class="swatch-holder bg-love-kiss switch-header-cs-class" data-class="bg-love-kiss header-text-light">
                                </div>
                                <div class="swatch-holder bg-premium-dark switch-header-cs-class" data-class="bg-premium-dark header-text-light">
                                </div>
                                <div class="swatch-holder bg-happy-green switch-header-cs-class" data-class="bg-happy-green header-text-light">
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <h3 class="themeoptions-heading">
                    <div>Sidebar Options</div>
                    <button type="button" class="btn-pill btn-shadow btn-wide ml-auto btn btn-focus btn-sm switch-sidebar-cs-class" data-class="">
                        Restore Default
                    </button>
                </h3>
                <div class="p-3">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <h5 class="pb-2">Choose Color Scheme
                            </h5>
                            <div class="theme-settings-swatches">
                                <div class="swatch-holder bg-primary switch-sidebar-cs-class" data-class="bg-primary sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-secondary switch-sidebar-cs-class" data-class="bg-secondary sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-success switch-sidebar-cs-class" data-class="bg-success sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-info switch-sidebar-cs-class" data-class="bg-info sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-warning switch-sidebar-cs-class" data-class="bg-warning sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-danger switch-sidebar-cs-class" data-class="bg-danger sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-light switch-sidebar-cs-class" data-class="bg-light sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-dark switch-sidebar-cs-class" data-class="bg-dark sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-focus switch-sidebar-cs-class" data-class="bg-focus sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-alternate switch-sidebar-cs-class" data-class="bg-alternate sidebar-text-light">
                                </div>
                                <div class="divider">
                                </div>
                                <div class="swatch-holder bg-vicious-stance switch-sidebar-cs-class" data-class="bg-vicious-stance sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-midnight-bloom switch-sidebar-cs-class" data-class="bg-midnight-bloom sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-night-sky switch-sidebar-cs-class" data-class="bg-night-sky sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-slick-carbon switch-sidebar-cs-class" data-class="bg-slick-carbon sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-asteroid switch-sidebar-cs-class" data-class="bg-asteroid sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-royal switch-sidebar-cs-class" data-class="bg-royal sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-warm-flame switch-sidebar-cs-class" data-class="bg-warm-flame sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-night-fade switch-sidebar-cs-class" data-class="bg-night-fade sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-sunny-morning switch-sidebar-cs-class" data-class="bg-sunny-morning sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-tempting-azure switch-sidebar-cs-class" data-class="bg-tempting-azure sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-amy-crisp switch-sidebar-cs-class" data-class="bg-amy-crisp sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-heavy-rain switch-sidebar-cs-class" data-class="bg-heavy-rain sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-mean-fruit switch-sidebar-cs-class" data-class="bg-mean-fruit sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-malibu-beach switch-sidebar-cs-class" data-class="bg-malibu-beach sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-deep-blue switch-sidebar-cs-class" data-class="bg-deep-blue sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-ripe-malin switch-sidebar-cs-class" data-class="bg-ripe-malin sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-arielle-smile switch-sidebar-cs-class" data-class="bg-arielle-smile sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-plum-plate switch-sidebar-cs-class" data-class="bg-plum-plate sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-happy-fisher switch-sidebar-cs-class" data-class="bg-happy-fisher sidebar-text-dark">
                                </div>
                                <div class="swatch-holder bg-happy-itmeo switch-sidebar-cs-class" data-class="bg-happy-itmeo sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-mixed-hopes switch-sidebar-cs-class" data-class="bg-mixed-hopes sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-strong-bliss switch-sidebar-cs-class" data-class="bg-strong-bliss sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-grow-early switch-sidebar-cs-class" data-class="bg-grow-early sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-love-kiss switch-sidebar-cs-class" data-class="bg-love-kiss sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-premium-dark switch-sidebar-cs-class" data-class="bg-premium-dark sidebar-text-light">
                                </div>
                                <div class="swatch-holder bg-happy-green switch-sidebar-cs-class" data-class="bg-happy-green sidebar-text-light">
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <h3 class="themeoptions-heading">
                    <div>Main Content Options</div>
                    <button type="button" class="btn-pill btn-shadow btn-wide ml-auto active btn btn-focus btn-sm">Restore Default
                    </button>
                </h3>
                <div class="p-3">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <h5 class="pb-2">Page Section Tabs
                            </h5>
                            <div class="theme-settings-swatches">
                                <div role="group" class="mt-2 btn-group">
                                    <button type="button" class="btn-wide btn-shadow btn-primary btn btn-secondary switch-theme-class" data-class="body-tabs-line">
                                        Line
                                    </button>
                                    <button type="button" class="btn-wide btn-shadow btn-primary active btn btn-secondary switch-theme-class" data-class="body-tabs-shadow">
                                        Shadow
                                    </button>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="app-main">
    <div class="app-sidebar sidebar-shadow">
        <div class="app-header__logo">
            <div class="logo-src"></div>
            <div class="header__pane ml-auto">
                <div>
                    <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                        <span class="hamburger-box">
                            <span class="hamburger-inner"></span>
                        </span>
                    </button>
                </div>
            </div>
        </div>
        <div class="app-header__mobile-menu">
            <div>
                <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                    <span class="hamburger-box">
                        <span class="hamburger-inner"></span>
                    </span>
                </button>
            </div>
        </div>
        <div class="app-header__menu">
            <span>
                <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                    <span class="btn-icon-wrapper">
                        <i class="fa fa-ellipsis-v fa-w-6"></i>
                    </span>
                </button>
            </span>
        </div>
        <div class="scrollbar-sidebar">
            <div class="app-sidebar__inner">
                <ul class="vertical-nav-menu">
                    <li class="app-sidebar__heading">Dashboards</li>
                    <li>
                        <a class="mm-active" href="<c:url value="/?lang=${locale}"/>" >
                            <i class="metismenu-icon pe-7s-home"></i>
                            <spring:message code="lbl.home"/>
                        </a>
                    </li>
                    <% if(PERM_READ_USER_LIST || PERM_READ_BRANCH_LIST || PERM_READ_ROLE_LIST){ %>
                    <li class="app-sidebar__heading">User Management</li>
                    <li>
                        <a href="#">
                            <i class="metismenu-icon pe-7s-user"></i>
                            <spring:message code="lbl.user"/>
                            <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>
                        </a>
                        <ul>
                            <% if(PERM_READ_USER_LIST){ %>
                            <li>
                                <a href="<c:url value="/user.html?lang=${locale}"/>">
                                    <i class="metismenu-icon"></i>
                                    <spring:message code="lbl.manageUuser"/>
                                </a>
                            </li>
                            <% } %>

                            <% if(PERM_READ_ROLE_LIST){ %>
                            <li>
                                <a href="<c:url value="/role.html?lang=${locale}"/>">
                                    <i class="metismenu-icon"></i>
                                    <spring:message code="lbl.manageRole"/>
                                </a>
                            </li>
                            <% } %>

                            <% if(PERM_READ_BRANCH_LIST){ %>
                            <li>
                                <a href="<c:url value="/branch-list.html?lang=${locale}"/>">
                                    <i class="metismenu-icon"></i>
                                    <spring:message code="lbl.manageBranch"/>
                                </a>
                            </li>
                            <% } %>
                        </ul>
                    </li>
                    <% } %>
                    <li>
                        <a href="#">
                            <i class="metismenu-icon pe-7s-car"></i>
                            Components
                            <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>
                        </a>
                        <ul>
                            <li>
                                <a href="components-tabs.html">
                                    <i class="metismenu-icon">
                                    </i>Tabs
                                </a>
                            </li>
                            <li>
                                <a href="components-accordions.html">
                                    <i class="metismenu-icon">
                                    </i>Accordions
                                </a>
                            </li>
                            <li>
                                <a href="components-notifications.html">
                                    <i class="metismenu-icon">
                                    </i>Notifications
                                </a>
                            </li>
                            <li>
                                <a href="components-modals.html">
                                    <i class="metismenu-icon">
                                    </i>Modals
                                </a>
                            </li>
                            <li>
                                <a href="components-progress-bar.html">
                                    <i class="metismenu-icon">
                                    </i>Progress Bar
                                </a>
                            </li>
                            <li>
                                <a href="components-tooltips-popovers.html">
                                    <i class="metismenu-icon">
                                    </i>Tooltips &amp; Popovers
                                </a>
                            </li>
                            <li>
                                <a href="components-carousel.html">
                                    <i class="metismenu-icon">
                                    </i>Carousel
                                </a>
                            </li>
                            <li>
                                <a href="components-calendar.html">
                                    <i class="metismenu-icon">
                                    </i>Calendar
                                </a>
                            </li>
                            <li>
                                <a href="components-pagination.html">
                                    <i class="metismenu-icon">
                                    </i>Pagination
                                </a>
                            </li>
                            <li>
                                <a href="components-scrollable-elements.html">
                                    <i class="metismenu-icon">
                                    </i>Scrollable
                                </a>
                            </li>
                            <li>
                                <a href="components-maps.html">
                                    <i class="metismenu-icon">
                                    </i>Maps
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li  >
                        <a href="tables-regular.html">
                            <i class="metismenu-icon pe-7s-display2"></i>
                            Tables
                        </a>
                    </li>
                    <li class="app-sidebar__heading">Widgets</li>
                    <li>
                        <a href="dashboard-boxes.html">
                            <i class="metismenu-icon pe-7s-display2"></i>
                            Dashboard Boxes
                        </a>
                    </li>
                    <li class="app-sidebar__heading">Forms</li>
                    <li>
                        <a href="forms-controls.html">
                            <i class="metismenu-icon pe-7s-mouse">
                            </i>Forms Controls
                        </a>
                    </li>
                    <li>
                        <a href="forms-layouts.html">
                            <i class="metismenu-icon pe-7s-eyedropper">
                            </i>Forms Layouts
                        </a>
                    </li>
                    <li>
                        <a href="forms-validation.html">
                            <i class="metismenu-icon pe-7s-pendrive">
                            </i>Forms Validation
                        </a>
                    </li>
                    <li class="app-sidebar__heading">Charts</li>
                    <li>
                        <a href="charts-chartjs.html">
                            <i class="metismenu-icon pe-7s-graph2">
                            </i>ChartJS
                        </a>
                    </li>
                    <li class="app-sidebar__heading">PRO Version</li>
                    <li>
                        <a href="https://dashboardpack.com/theme-details/architectui-dashboard-html-pro/" target="_blank">
                            <i class="metismenu-icon pe-7s-graph2">
                            </i>
                            Upgrade to PRO
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <%--<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"--%>
    <%--	 id="mainNav">--%>
    <%--	<a class="navbar-brand" href="<c:url value="/?lang=${locale}"/>"><img--%>
    <%--			src="<c:url value="/resources/img/logo-inverse.png"/>" style = "height: 46px"></a>--%>

    <%--	<div class="collapse navbar-collapse" id="navbarResponsive">--%>


    <%--		<ul class="navbar-nav ml-auto">--%>

    <%--			<li class="nav-item dropdown">--%>
    <%--				<a class="nav-link dropdown-toggle mr-lg-2" href="<c:url value="/?lang=${locale}"/>" >--%>
    <%--					<strong><spring:message code="lbl.home"/></strong>--%>
    <%--				</a>--%>
    <%--			</li>--%>

    <%--			<%if (MEMBER_APPROVAL) {%>--%>
    <%--			<li class="nav-item dropdown">--%>
    <%--				<a class="nav-link dropdown-toggle mr-lg-2" href="--%>
    <%--					<c:url value="/client/household-member-list.html"/>">--%>
    <%--					<strong><spring:message code="lbl.memberApproval"/></strong>--%>
    <%--				</a>--%>
    <%--			</li>--%>
    <%--			<%}%>--%>

    <%--			<%if(PERM_WRITE_FACILITY || PERM_READ_FACILITY || PERM_UPLOAD_FACILITY_CSV ){ %>--%>
    <%--			<li class="nav-item dropdown"><a--%>
    <%--					class="nav-link dropdown-toggle mr-lg-2" id="facilityDropdown"--%>
    <%--					href="#" data-toggle="dropdown"><spring:message code="lbl.facility"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>

    <%--					<% if(PERM_WRITE_FACILITY){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/facility/add.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.registration"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(PERM_READ_FACILITY){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/cbhc-dashboard?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.comunityClinic"/> </strong>--%>

    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_UPLOAD_FACILITY_CSV){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/facility/upload_csv.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.facilityUpload"/> </strong>--%>
    <%--					</a>--%>

    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_UPLOAD_HEALTH_ID){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/healthId/upload_csv.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.healthIdUpload"/> </strong>--%>
    <%--					</a>--%>

    <%--					<% } %>--%>
    <%--				</div></li>--%>
    <%--			<% } %>--%>


    <%--			<%if(PERM_UPLOAD_FORM || PERM_DOWNLOAD_FORM ){ %>--%>
    <%--			<li class="nav-item dropdown">--%>
    <%--				<a class="nav-link dropdown-toggle mr-lg-2" id="formDropdown" href="#" data-toggle="dropdown">--%>
    <%--					<spring:message code="lbl.form"/>--%>
    <%--				</a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<% if(PERM_UPLOAD_FORM){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/form/uploadForm.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.uploadForm"/> </strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_DOWNLOAD_FORM){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/form/downloadForm.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.formList"/> </strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--				</div>--%>
    <%--			</li>--%>
    <%--			<% } %>--%>


    <%--			<%if(PERM_READ_HOUSEHOLD_LIST || PERM_READ_MOTHER_LIST || PERM_READ_CHILD_LIST || PERM_READ_MEMBER_LIST--%>
    <%--					||PERM_READ_SIMILAR_EVENT_CLIENT || PERM_READ_SIMILARITY_DEFINITION ){ %>--%>
    <%--			<li class="nav-item dropdown">--%>
    <%--				<a class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown" href="#" data-toggle="dropdown">--%>
    <%--					<spring:message code="lbl.client"/>--%>
    <%--				</a>--%>
    <%--				<div class="dropdown-menu">--%>

    <%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD")){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/household.html?lang=${locale}"/>">--%>
    <%--						<strong><spring:message code="lbl.household"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER")){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/mother.html?lang=${locale}"/>"> <strong><spring:message code="lbl.mother"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD")){ %>--%>

    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/child.html?lang=${locale}"/>"> <strong><spring:message code="lbl.child"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER")){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/member.html?lang=${locale}"/>"> <strong><spring:message code="lbl.member"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/client/similarClient.html?lang=${locale}"/>">--%>
    <%--						<strong><spring:message code="lbl.similarCLient"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/similarEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarEvent"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(PERM_READ_SIMILARITY_DEFINITION){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/similarityDefinitionOfClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarclientRuleDefination"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--					<% if(PERM_READ_SIMILARITY_DEFINITION){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/client/similarityDefinitionOfEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similareventRuleDefination"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>

    <%--				</div>--%>
    <%--			</li>--%>
    <%--			<% } %>--%>


    <%--			<%if(CHILD_GROWTH_REPORT || CHILD_GROWTH_SUMMARY_REPORT || ANALYTICS || PERM_READ_AGGREGATED_REPORT){ %>--%>
    <%--			<li class="nav-item dropdown"><a--%>
    <%--					class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown" href="#"--%>
    <%--					data-toggle="dropdown"><spring:message code="lbl.report"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<% if(CHILD_GROWTH_REPORT){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/report/child-growth.html?lang=${locale}"/>">--%>
    <%--						<strong> <spring:message code="lbl.childGrowthReport"/></strong></a>--%>
    <%--					<% } %>--%>
    <%--					<% if(CHILD_GROWTH_SUMMARY_REPORT){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/report/summary.html?lang=${locale}"/>">--%>
    <%--						<strong><spring:message code="lbl.childGrowthSummaryReport"/> </strong></a>--%>
    <%--					<% } %>--%>

    <%--					<% if(ANALYTICS){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--										<a class="dropdown-item" href="<c:url value="/analytics/analytics.html?lang=${locale}"/>">--%>
    <%--										<strong><spring:message code="lbl.analytics"/></strong></a>--%>

    <%--					<% } %>--%>

    <%--					<% if(PERM_READ_AGGREGATED_REPORT){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/report/householdDataReport.html?lang=${locale}&address_field=division&searched_value=empty"/>">--%>
    <%--						<strong><spring:message code="lbl.aggregatedReport"/></strong></a>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/report/clientDataReport.html?lang=${locale}"/>">--%>
    <%--						<strong><spring:message code="lbl.clientDataReport"/></strong></a>--%>
    <%--					<% } %>--%>
    <%--				</div>--%>
    <%--			</li>--%>
    <%--			<% } %>--%>

    <%--			<%if(PERM_READ_USER_LIST || PERM_READ_ROLE_LIST){ %>--%>
    <%--			<li class="nav-item dropdown"><a--%>
    <%--					class="nav-link dropdown-toggle mr-lg-2" id="userDropdown" href="#"--%>
    <%--					data-toggle="dropdown"> <spring:message code="lbl.user"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<% if(PERM_READ_USER_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/user.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.manageUuser"/></strong> </a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_READ_ROLE_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/role.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.manageRole"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_READ_BRANCH_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/branch-list.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.manageBranch"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--				</div></li>--%>
    <%--			<% } %>--%>

    <%--			<%if(PERM_READ_LOCATION_TAG_LIST || PERM_READ_LOCATION_LIST || PERM_UPLOAD_LOCATION){ %>--%>
    <%--			<li class="nav-item dropdown"><a--%>
    <%--					class="nav-link dropdown-toggle mr-lg-2" id="locationDropdown"--%>
    <%--					href="#" data-toggle="dropdown"> <spring:message code="lbl.location"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<% if(PERM_READ_LOCATION_TAG_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/location/tag/list.html?lang=${locale}"/>">--%>
    <%--						<strong> <spring:message code="lbl.manageTag"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_READ_LOCATION_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/location/location.html?lang=${locale}"/>">--%>
    <%--						<strong> <spring:message code="lbl.manageLocation"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_UPLOAD_LOCATION){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/location/upload_csv.html?lang=${locale}"/>">--%>
    <%--						<strong><spring:message code="lbl.uploadLocation"/></strong></a>--%>
    <%--					<% } %>--%>
    <%--				</div></li>--%>
    <%--			<% } %>--%>

    <%--			<%if(PERM_READ_TEAM_LIST || PERM_READ_TEAM_MEMBER_LIST){ %>--%>
    <%--			<li class="nav-item dropdown"><a--%>
    <%--					class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"--%>
    <%--					data-toggle="dropdown"><spring:message code="lbl.team"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<% if(PERM_READ_TEAM_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/team/list.html?lang=${locale}"/>">--%>
    <%--						<strong> <spring:message code="lbl.manageTeam"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_READ_TEAM_MEMBER_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.manageTeammember"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--				</div>--%>
    <%--			</li>--%>
    <%--			<% } %>--%>

    <%--			<%if(PERM_READ_EXPORT_LIST){ %>--%>
    <%--			<li class="nav-item dropdown"><a--%>
    <%--					class="nav-link dropdown-toggle mr-lg-2" id="exportDropdown" href="#"--%>
    <%--					data-toggle="dropdown"><spring:message code="lbl.exportTitle"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<% if(PERM_READ_EXPORT_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/export/exportlist.html?lang=${locale}"/>">--%>
    <%--						<strong> <spring:message code="lbl.exportList"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--					<% if(PERM_EXPORT_LIST){ %>--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item"--%>
    <%--					   href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>--%>
    <%--						<spring:message code="lbl.exportFile"/></strong>--%>
    <%--					</a>--%>
    <%--					<% } %>--%>
    <%--				</div>--%>
    <%--			</li>--%>
    <%--			<% } %>--%>
    <%--			<li class="nav-item dropdown">--%>
    <%--				<a class="nav-link dropdown-toggle mr-lg-2" id="languageDropdown" href="#"--%>
    <%--				   data-toggle="dropdown"><spring:message code="lbl.language"/> </a>--%>
    <%--				<div class="dropdown-menu">--%>
    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/?lang=bn"/>">--%>
    <%--						<strong> <spring:message code="lbl.bengali"/></strong>--%>
    <%--					</a>--%>

    <%--					<div class="dropdown-divider"></div>--%>
    <%--					<a class="dropdown-item" href="<c:url value="/?lang=en"/>">--%>
    <%--						<strong><spring:message code="lbl.english"/></strong>--%>
    <%--					</a>--%>
    <%--				</div>--%>
    <%--			</li>--%>
    <%--			<li class="nav-item"><a class="nav-link" data-toggle="modal"--%>
    <%--									data-target="#exampleModal">(<%=user.getUsername()%>) <i class="fa fa-fw fa-sign-out"></i><spring:message code="lbl.logout"/>--%>
    <%--			</a></li>--%>
    <%--		</ul>--%>
    <%--	</div>--%>
    <%--</nav>--%>

