package com.osm.<package_name>.oispdp21.datamodel;
import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
public class slbinv_cs_invdet implements Serializable {
	private static final long serialVersionUID = 1L;
	private Character abs_approved;
	private String ballistic_gauges;
	private String boat_id;
	private Integer boat_lotnr;
	private Character cat_approved;
	private Date cdat;
	private String cmt;
	private String csloc;
	private Short csnr;
	private Integer cswt;
	private Character dnv_approved;
	private String hold_cmt;
	private Date hold_dat;
	private Integer hold_tim;
	private String hold_userid;
	private String htnr;
	private Character lloyds_approved;
	private Character mfsts;
	private Integer mlcod;
	private Character mold;
	private Character nafta_alloy;
	private Integer nr_days_old;
	private Short orgcsnr;
	private Short pcsnr;
	private Date pdat;
	private String po_txt;
	private Integer ponr;
	private Short ponr_itm;
	private String ponr_itm_id;
	private String ppc_label;
	private Character prcsts;
	private String provider_userid;
	private String sku_mgw;
	private String slbsts;
	private String supplier;
	private Float thk;
	private Float xdim;
	private Integer yard_seq;
	private Float ydim;
	
	public slbinv_cs_invdet(Character abs_approved,
			String ballistic_gauges,
			String boat_id,
			Integer boat_lotnr,
			Character cat_approved,
			Date cdat,
			String cmt,
			String csloc,
			Short csnr,
			Integer cswt,
			Character dnv_approved,
			String hold_cmt,
			Date hold_dat,
			Integer hold_tim,
			String hold_userid,
			String htnr,
			Character lloyds_approved,
			Character mfsts,
			Integer mlcod,
			Character mold,
			Character nafta_alloy,
			Integer nr_days_old,
			Short orgcsnr,
			Short pcsnr,
			Date pdat,
			String po_txt,
			Integer ponr,
			Short ponr_itm,
			String ponr_itm_id,
			String ppc_label,
			Character prcsts,
			String provider_userid,
			String sku_mgw,
			String slbsts,
			String supplier,
			Float thk,
			Float xdim,
			Integer yard_seq,
			Float ydim) {
		this.abs_approved = abs_approved;
		this.ballistic_gauges = ballistic_gauges;
		this.boat_id = boat_id;
		this.boat_lotnr = boat_lotnr;
		this.cat_approved = cat_approved;
		this.cdat = cdat;
		this.cmt = cmt;
		this.csloc = csloc;
		this.csnr = csnr;
		this.cswt = cswt;
		this.dnv_approved = dnv_approved;
		this.hold_cmt = hold_cmt;
		this.hold_dat = hold_dat;
		this.hold_tim = hold_tim;
		this.hold_userid = hold_userid;
		this.htnr = htnr;
		this.lloyds_approved = lloyds_approved;
		this.mfsts = mfsts;
		this.mlcod = mlcod;
		this.mold = mold;
		this.nafta_alloy = nafta_alloy;
		this.nr_days_old = nr_days_old;
		this.orgcsnr = orgcsnr;
		this.pcsnr = pcsnr;
		this.pdat = pdat;
		this.po_txt = po_txt;
		this.ponr = ponr;
		this.ponr_itm = ponr_itm;
		this.ponr_itm_id = ponr_itm_id;
		this.ppc_label = ppc_label;
		this.prcsts = prcsts;
		this.provider_userid = provider_userid;
		this.sku_mgw = sku_mgw;
		this.slbsts = slbsts;
		this.supplier = supplier;
		this.thk = thk;
		this.xdim = xdim;
		this.yard_seq = yard_seq;
		this.ydim = ydim;
	}

	@Column(name = "abs_approved")
	public Character getAbs_approved() {
		return abs_approved;
	}

	public void setAbs_approved(Character abs_approved) {
		this.abs_approved = abs_approved;
	}

	@Column(name = "ballistic_gauges")
	public String getBallistic_gauges() {
		return ballistic_gauges;
	}

	public void setBallistic_gauges(String ballistic_gauges) {
		this.ballistic_gauges = ballistic_gauges;
	}

	@Column(name = "boat_id")
	public String getBoat_id() {
		return boat_id;
	}

	public void setBoat_id(String boat_id) {
		this.boat_id = boat_id;
	}

	@Column(name = "boat_lotnr")
	public Integer getBoat_lotnr() {
		return boat_lotnr;
	}

	public void setBoat_lotnr(Integer boat_lotnr) {
		this.boat_lotnr = boat_lotnr;
	}

	@Column(name = "cat_approved")
	public Character getCat_approved() {
		return cat_approved;
	}

	public void setCat_approved(Character cat_approved) {
		this.cat_approved = cat_approved;
	}

	@Column(name = "cdat")
	public Date getCdat() {
		return cdat;
	}

	public void setCdat(Date cdat) {
		this.cdat = cdat;
	}

	@Column(name = "cmt")
	public String getCmt() {
		return cmt;
	}

	public void setCmt(String cmt) {
		this.cmt = cmt;
	}

	@Column(name = "csloc")
	public String getCsloc() {
		return csloc;
	}

	public void setCsloc(String csloc) {
		this.csloc = csloc;
	}

	@Column(name = "csnr")
	public Short getCsnr() {
		return csnr;
	}

	public void setCsnr(Short csnr) {
		this.csnr = csnr;
	}

	@Column(name = "cswt")
	public Integer getCswt() {
		return cswt;
	}

	public void setCswt(Integer cswt) {
		this.cswt = cswt;
	}

	@Column(name = "dnv_approved")
	public Character getDnv_approved() {
		return dnv_approved;
	}

	public void setDnv_approved(Character dnv_approved) {
		this.dnv_approved = dnv_approved;
	}

	@Column(name = "hold_cmt")
	public String getHold_cmt() {
		return hold_cmt;
	}

	public void setHold_cmt(String hold_cmt) {
		this.hold_cmt = hold_cmt;
	}

	@Column(name = "hold_dat")
	public Date getHold_dat() {
		return hold_dat;
	}

	public void setHold_dat(Date hold_dat) {
		this.hold_dat = hold_dat;
	}

	@Column(name = "hold_tim")
	public Integer getHold_tim() {
		return hold_tim;
	}

	public void setHold_tim(Integer hold_tim) {
		this.hold_tim = hold_tim;
	}

	@Column(name = "hold_userid")
	public String getHold_userid() {
		return hold_userid;
	}

	public void setHold_userid(String hold_userid) {
		this.hold_userid = hold_userid;
	}

	@Column(name = "htnr")
	public String getHtnr() {
		return htnr;
	}

	public void setHtnr(String htnr) {
		this.htnr = htnr;
	}

	@Column(name = "lloyds_approved")
	public Character getLloyds_approved() {
		return lloyds_approved;
	}

	public void setLloyds_approved(Character lloyds_approved) {
		this.lloyds_approved = lloyds_approved;
	}

	@Column(name = "mfsts")
	public Character getMfsts() {
		return mfsts;
	}

	public void setMfsts(Character mfsts) {
		this.mfsts = mfsts;
	}

	@Column(name = "mlcod")
	public Integer getMlcod() {
		return mlcod;
	}

	public void setMlcod(Integer mlcod) {
		this.mlcod = mlcod;
	}

	@Column(name = "mold")
	public Character getMold() {
		return mold;
	}

	public void setMold(Character mold) {
		this.mold = mold;
	}

	@Column(name = "nafta_alloy")
	public Character getNafta_alloy() {
		return nafta_alloy;
	}

	public void setNafta_alloy(Character nafta_alloy) {
		this.nafta_alloy = nafta_alloy;
	}

	@Column(name = "nr_days_old")
	public Integer getNr_days_old() {
		return nr_days_old;
	}

	public void setNr_days_old(Integer nr_days_old) {
		this.nr_days_old = nr_days_old;
	}

	@Column(name = "orgcsnr")
	public Short getOrgcsnr() {
		return orgcsnr;
	}

	public void setOrgcsnr(Short orgcsnr) {
		this.orgcsnr = orgcsnr;
	}

	@Column(name = "pcsnr")
	public Short getPcsnr() {
		return pcsnr;
	}

	public void setPcsnr(Short pcsnr) {
		this.pcsnr = pcsnr;
	}

	@Column(name = "pdat")
	public Date getPdat() {
		return pdat;
	}

	public void setPdat(Date pdat) {
		this.pdat = pdat;
	}

	@Column(name = "po_txt")
	public String getPo_txt() {
		return po_txt;
	}

	public void setPo_txt(String po_txt) {
		this.po_txt = po_txt;
	}

	@Column(name = "ponr")
	public Integer getPonr() {
		return ponr;
	}

	public void setPonr(Integer ponr) {
		this.ponr = ponr;
	}

	@Column(name = "ponr_itm")
	public Short getPonr_itm() {
		return ponr_itm;
	}

	public void setPonr_itm(Short ponr_itm) {
		this.ponr_itm = ponr_itm;
	}

	@Column(name = "ponr_itm_id")
	public String getPonr_itm_id() {
		return ponr_itm_id;
	}

	public void setPonr_itm_id(String ponr_itm_id) {
		this.ponr_itm_id = ponr_itm_id;
	}

	@Column(name = "ppc_label")
	public String getPpc_label() {
		return ppc_label;
	}

	public void setPpc_label(String ppc_label) {
		this.ppc_label = ppc_label;
	}

	@Column(name = "prcsts")
	public Character getPrcsts() {
		return prcsts;
	}

	public void setPrcsts(Character prcsts) {
		this.prcsts = prcsts;
	}

	@Column(name = "provider_userid")
	public String getProvider_userid() {
		return provider_userid;
	}

	public void setProvider_userid(String provider_userid) {
		this.provider_userid = provider_userid;
	}

	@Column(name = "sku_mgw")
	public String getSku_mgw() {
		return sku_mgw;
	}

	public void setSku_mgw(String sku_mgw) {
		this.sku_mgw = sku_mgw;
	}

	@Column(name = "slbsts")
	public String getSlbsts() {
		return slbsts;
	}

	public void setSlbsts(String slbsts) {
		this.slbsts = slbsts;
	}

	@Column(name = "supplier")
	public String getSupplier() {
		return supplier;
	}

	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}

	@Column(name = "thk")
	public Float getThk() {
		return thk;
	}

	public void setThk(Float thk) {
		this.thk = thk;
	}

	@Column(name = "xdim")
	public Float getXdim() {
		return xdim;
	}

	public void setXdim(Float xdim) {
		this.xdim = xdim;
	}

	@Column(name = "yard_seq")
	public Integer getYard_seq() {
		return yard_seq;
	}

	public void setYard_seq(Integer yard_seq) {
		this.yard_seq = yard_seq;
	}

	@Column(name = "ydim")
	public Float getYdim() {
		return ydim;
	}

	public void setYdim(Float ydim) {
		this.ydim = ydim;
	}

}
